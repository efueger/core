class CustomerMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: Figaro.env.no_reply_email

  def login_details(customer)
    @distributor = customer.distributor
    @customer = customer

    headers['X-MC-Tags'] = "customer,login_details,#{@distributor.name.parameterize}"

    mail to: @customer.email,
         from: "#{@distributor.email_name} <#{Figaro.env.no_reply_email}>",
         reply_to: @distributor.support_email,
         subject: "Your Login details for #{@distributor.name}"
  end

  def orders_halted(customer)
    @distributor = customer.distributor
    @customer = customer
    @oops = ['Uh-oh', 'Whoops', 'Oooops'].sample

    headers['X-MC-Tags'] = "customer,orders_halted,#{@distributor.name.parameterize}"

    mail to: @customer.email,
         from: "#{@distributor.email_name} <#{Figaro.env.no_reply_email}>",
         cc: @distributor.support_email,
         reply_to: @distributor.support_email,
         subject: "#{@oops}, your #{@distributor.name} deliveries have been put on hold"
  end

  def remind_orders_halted(customer)
    @distributor = customer.distributor
    @customer = customer
    @oops = ['Uh-oh', 'Whoops', 'Oooops'].sample

    headers['X-MC-Tags'] = "customer,remind_orders_halted,#{@distributor.name.parameterize}"

    mail to: @customer.email,
         from: "#{@distributor.email_name} <#{Figaro.env.no_reply_email}>",
         cc: @distributor.support_email,
         reply_to: @distributor.support_email,
         subject: "#{@oops}, your #{@distributor.name} deliveries are on hold"
  end

  def email_template(recipient, email)
    distributor = if recipient.respond_to? :distributor
      recipient.distributor
    else
      recipient
    end

    headers['X-MC-Tags'] = "customer,email_template,#{distributor.name.parameterize}"

    mail to: recipient.email,
         from: "#{distributor.email_name} <#{Figaro.env.no_reply_email}>",
         reply_to: distributor.support_email,
         subject: email.subject do |format|
          format.text { render text: email.body }
          format.html { render text: simple_format(email.body) }
         end
  end

  # FIXME we are not doing invoicing at the moment
  def invoice invoice
    #@invoice = invoice
    #@account = invoice.account
    #@customer = @account.customer
    #@distributor = @account.distributor

    #mail to: @customer.email,
         #from: "#{@distributor.email_name} <#{Figaro.env.no_reply_email}>",
         #reply_to: @distributor.support_email,
         #subject: "Your #{@distributor.name} Bill/Account Statement ##{@invoice.number}"
  end
end
