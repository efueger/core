class Admin::DashboardController < Admin::BaseController
  def index
    @distributors = Distributor.
      where("current_sign_in_at > ?", 1.month.ago).
      select { |d| d.transactional_customer_count > 10}.
      sort_by(&:transactional_customer_count).reverse

    demo = Distributor.find_by(email: "demo@buckybox.com")
    @distributors = [demo] | @distributors if demo

    @cron_logs = CronLog.limit(10)
  end
end
