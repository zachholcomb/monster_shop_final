class Admin::OrdersController < Admin::BaseController
  def update 
    order = Order.find(params[:order_id])
    order.update(status: 2)
    redirect_to admin_dashboard_path
  end
end