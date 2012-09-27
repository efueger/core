class Webstore
  attr_reader :controller, :distributor, :order

  def initialize(controller, distributor)
    @controller  = controller
    @distributor = distributor

    webstore_session = @controller.session[:webstore]
    @order = WebstoreOrder.find_by_id(webstore_session[:webstore_order_id]) if webstore_session
  end

  def process_params
    webstore_params = @controller.params[:webstore_order]

    start_order(webstore_params[:box_id])              if webstore_params[:box_id]
    customise_order(webstore_params)                   if webstore_params[:customise] || webstore_params[:extras]
    login_customer(webstore_params[:user])             if webstore_params[:user]
    update_delivery_information(webstore_params)       if webstore_params[:route]
    add_address_information(webstore_params[:address]) if webstore_params[:address]
    complete_order                                     if webstore_params[:complete]

    @order.save
  end

  def next_step
    @order.status
  end

  private

  def to_session
    { webstore_order_id: @order.id }
  end

  def start_order(box_id)
    box = Box.where(id: box_id, distributor_id: @distributor.id).first
    customer = @controller.current_customer

    @order = WebstoreOrder.create(box: box, remote_ip: @controller.request.remote_ip)
    @order.account = customer.account if customer

    if box.customisable?
      @order.customise_step
    else
      if @controller.customer_signed_in?
        @order.delivery_step
      else
        @order.login_step
      end
    end

    @controller.session[:webstore] = to_session
  end

  def customise_order(customise)
    customise_params = customise[:customise]
    add_exclusions_to_order(customise_params[:dislikes_input]) if customise_params
    add_substitutes_to_order(customise_params[:likes_input])   if customise_params

    extra_params = customise[:extras]
    add_extras_to_order(extra_params) if customise[:extras]

    if @controller.customer_signed_in? && @controller.current_customer.distributor == @distributor
      @order.delivery_step
    else
      @order.login_step
    end
  end

  def login_customer(user_information)
    email    = user_information[:email]
    customer = Customer.find_by_email(email)

    if customer.nil?
      customer = distributor.customers.new(email: email)
      customer.route = Route.default_route(@distributor)
      customer.first_name = 'Webstore Order Customer'
      customer.save

      CustomerMailer.login_details(customer).deliver

      @controller.sign_in(customer)
    elsif customer.valid_password?(user_information[:password]) && customer.distributor == @distributor
      @controller.sign_in(customer)
    end

    @order.account = customer.account

    if @controller.customer_signed_in?
      @order.delivery_step
    else
      @controller.flash[:error] = 'Login failed, please try again.'
      @order.login_step
    end
  end

  def update_delivery_information(delivery_information)
    assign_route(delivery_information[:route])                      if delivery_information[:route]
    set_schedule(delivery_information[:schedule])                   if delivery_information[:schedule]
    assign_extras_frequency(delivery_information[:extra_frequency]) if delivery_information[:extra_frequency]

    @order.complete_step
  end

  def add_address_information(address_information)
    customer = @order.customer
    customer.first_name = address_information[:name]

    address = customer.address || Address.new(customer: customer)
    address.address_1 = address_information[:street_address]
    address.address_2 = address_information[:street_address_2]
    address.suburb    = address_information[:suburb]
    address.city      = address_information[:city]
    address.postcode  = address_information[:post_code]

    customer.save

    @order.placed_step
  end

  def complete_order
    if @order.create_order
      @controller.flash[:notice] = 'Your order has been placed'
      @order.placed_step
    else
      @controller.flash[:error] = 'There was a problem completing your order'
      @order.complete_step
    end
  end

  def add_exclusions_to_order(exclusions)
    exclusions.delete('')
    @order.exclusions = exclusions
  end

  def add_substitutes_to_order(substitutions)
    substitutions.delete('')
    @order.substitutions = substitutions
  end

  def add_extras_to_order(extras)
    extras.delete('add_extra')
    @order.extras = extras.select { |k,v| v.to_i > 0 }
  end

  def assign_route(route_information)
    route_id       = route_information[:route]
    customer       = @order.customer
    customer.route = Route.find(route_id)
    customer.save(validate: false)
  end

  def set_schedule(schedule_information)
    frequency = schedule_information[:frequency]
    start_time = Time.zone.parse(schedule_information[:start_date])

    @order.frequency = frequency

    if frequency == 'single'
      @order.create_schedule_for(:schedule, start_time, frequency)
    else
      days_by_number = schedule_information[:days].map { |d| d.first.to_i }
      @order.create_schedule_for(:schedule, start_time, frequency, days_by_number)
    end
  end

  def assign_extras_frequency(extra_information)
    extra_frequency = extra_information[:extra_frequency]
    @order.extras_one_off = (extra_frequency == 'true' ? true : false)
  end
end
