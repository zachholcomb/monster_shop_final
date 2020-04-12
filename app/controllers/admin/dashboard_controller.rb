class Admin::DashboardController < Admin::BaseController
  before_action :require_admin

  def show
    @orders = Order.sort_status
  end
  
end
