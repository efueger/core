class Distributor::CustomersController < Distributor::ResourceController
  respond_to :html, :xml, :json

  before_filter :get_form_type, only: [:edit, :update]
  before_filter :get_email_templates, only: [:index, :show]

  def index
    if current_distributor.routes.empty?
      redirect_to distributor_settings_routes_url, alert: 'You must create a route before you can create users.' and return
    end

    index! do
      @show_tour = current_distributor.customers_index_intro
    end
  end

  def new
    new! do
      @address = @customer.build_address
    end
  end

  def create
    create! do |success, failure|
      success.html do
        usercycle.event(current_distributor, "distributor_created_customer")
        redirect_to distributor_customer_url(@customer)
      end
    end
  end

  def edit
    edit!
  end

  def update
    update! do |success, failure|
      success.html { redirect_to distributor_customer_url(@customer) }
      failure.html do
        if (phone_errors = @customer.address.errors.get(:phone_number))
          # Highlight all missing phone fields
          phone_errors.each do |error|
            PhoneCollection.attributes.each do |type|
              @customer.address.errors[type] << error
            end
          end
        end

        render get_form_type
      end
    end
  end

  def show
    show! do
      @address          = @customer.address
      @account          = @customer.account
      @orders           = @account.orders.active
      @deliveries       = @account.deliveries.ordered
      @transactions     = account_transactions(@account)
      @show_more_link   = (@transactions.size != @account.transactions.count)
      @transactions_sum = @account.calculate_balance
      @show_tour        = current_distributor.customers_show_intro
    end
  end

  def send_login_details
    @customer = Customer.find(params[:id])

    @customer.randomize_password
    @customer.save

    CustomerMailer.raise_errors do
      if !@customer.send_email?
        flash[:error] = "Sending emails is disabled, login details not sent"
      elsif @customer.send_login_details
        flash[:notice] = "Login details successfully sent"
      else
        flash[:error] = "Login details failed to send"
      end
    end

    redirect_to distributor_customer_url(@customer)
  end

  def email
    email_template = EmailTemplate.new(
      params[:email_template][:subject],
      params[:email_template][:body]
    )

    link_action = params[:link_action]
    link_action = "send" if link_action.empty?

    if !email_template.valid? && link_action != "delete"
      render json: { message: email_template.errors.join('<br>') },
             status: :unprocessable_entity

      return
    end

    message = email_templates_update(link_action, email_template)

    if message && current_distributor.save
      flash[:notice] = message if link_action == "send"
      render json: { link_action => true, message: message }
    else
      render json: current_distributor.errors.full_messages,
             status: :unprocessable_entity
    end
  end

protected

  def get_form_type
    @form_type = (params[:form_type].to_s == 'delivery' ? 'delivery_form' : 'personal_form')
  end

  def collection
    @customers = end_of_association_chain

    @customers = @customers.tagged_with(params[:tag]) unless params[:tag].blank?

    unless params[:query].blank?
      query = params[:query].gsub(/\./, '')
      if params[:query].to_i == 0
        @customers = current_distributor.customers.search(query)
      else
        @customers = current_distributor.customers.where(number: query.to_i)
      end
    end

    @customers = @customers.ordered_by_next_delivery.includes(account: {route: {}}, tags: {}, next_order: {box: {}})
  end

private

  def get_email_templates
    @email_templates = current_distributor.email_templates
  end

  def email_templates_update action, email_template
    selected_email_template_id = params[:selected_email_template_id].to_i
    recipient_ids = params[:recipient_ids].split(',').map(&:to_i)
    message = nil

    case action
    when "update"
      current_distributor.email_templates[selected_email_template_id] = email_template
      message = "Your changes have been saved."

    when "delete"
      deleted = current_distributor.email_templates.delete_at(selected_email_template_id)
      message = "Email template <em>#{deleted.subject}</em> has been deleted."

    when "save"
      current_distributor.email_templates << email_template
      message = "Your new email template <em>#{email_template.subject}</em> has been saved."

    when "preview"
      customer = Customer.find recipient_ids.first
      personalised_email = email_template.personalise(customer)
      CustomerMailer.email_template(current_distributor, personalised_email).deliver
      message = "A preview email has been sent to #{current_distributor.email}."

    when "send"
      if params[:commit]
        message = send_email recipient_ids, email_template
      end
    end

    message
  end

  def send_email recipient_ids, email
    recipient_ids.each do |id|
      customer = Customer.find id
      personalised_email = email.personalise(customer)

      CustomerMailer.delay(
        priority: Figaro.env.delayed_job_priority_high
      ).email_template(customer, personalised_email)
    end

    message = "Your email \"#{email.subject}\" is being sent to "
    message << if recipient_ids.size == 1
      Customer.find(recipient_ids.first).name
    else
      "#{recipient_ids.size} customers"
    end
    message << "..."
  end
end
