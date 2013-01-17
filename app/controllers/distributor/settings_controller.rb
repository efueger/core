class Distributor::SettingsController < Distributor::BaseController
  respond_to :html, :json

  def business_information
    time = Time.new
    @default_delivery_time  = Time.new(time.year, time.month, time.day, current_distributor.advance_hour)
    @default_delivery_days  = current_distributor.advance_days
    @default_automatic_time = Time.new(time.year, time.month, time.day, current_distributor.automatic_delivery_hour)
  end

  def spend_limit_confirmation
    spend_limit = params[:spend_limit].to_f * 100.0
    update_existing = params[:update_existing] == '1'
    count = current_distributor.number_of_customers_halted_after_update(spend_limit, update_existing)
    if count > 0
      render text: "Updating the spend limit will halt #{count} #{count==1? 'customer' : 'customers'} deliveries.  #{"They will be emailed that their account has been halted until payment is made.  " if current_distributor.send_halted_email? }Are you sure?"
    else
      render text: "safe"
    end
  end

  def routes
    @route = Route.new
    @routes = current_distributor.routes
  end

  def extras
    @extra = Extra.new
    @extras = current_distributor.extras.alphabetically
  end

  def boxes
    @box = Box.new
    @boxes = current_distributor.boxes
  end

  def bank_information
    @bank_information = current_distributor.bank_information || BankInformation.new
  end

  def invoice_information
    @invoice_information = current_distributor.invoice_information || InvoiceInformation.new
  end

  def stock_list
    @edit_mode = params[:edit] || false

    @line_items = current_distributor.line_items
    @placeholder_text = 'Enter items one per line or separated by commas. e.g. Silverbeet, Cabbage, Celery'
  end

  def reporting
  end
end
