class Distributor::ReportsController < Distributor::BaseController
  def index
  end

  def transaction_history
    report = Report::TransactionHistory.new(distributor: current_distributor, from: params[:start], to: params[:to])
    tracking.event(current_distributor, "exported_transaction_history") unless current_admin.present?
    send_csv(report.name, report.data)
  end

  def customer_account_history
    report = Report::CustomerAccountHistory.new(distributor: current_distributor, date: params[:to])
    tracking.event(current_distributor, "exported_account_history") unless current_admin.present?
    send_csv(report.name, report.data)
  end
end
