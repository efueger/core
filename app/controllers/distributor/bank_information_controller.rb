class Distributor::BankInformationController < Distributor::BaseController
  def update
    bank_information = current_distributor.bank_information

    if bank_information.update_attributes(params[:bank_information])
      tracking.event(current_distributor, "new_bank_information") unless current_admin.present?
      redirect_to distributor_settings_payments_url, notice: 'Your payment information was successfully updated.'
    else
      render 'distributor/settings/payments', locals: { payments: bank_information }
    end
  end
end
