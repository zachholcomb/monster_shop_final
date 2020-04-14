class Merchant::OrdersController < ApplicationController
  before_action :require_merchant

  def show
    @order = Order.find(params[:id])
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
