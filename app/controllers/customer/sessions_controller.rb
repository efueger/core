class Customer::SessionsController < Devise::SessionsController
  include Devise::CustomControllerParameters

  def new
    analytical.event('view_customer_sign_in')
    super
  end

  def create
    analytical.event('customer_signed_in')
    super
  end
end

