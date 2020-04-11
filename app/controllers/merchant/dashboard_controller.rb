class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def show
    @merchant = current_user.merchants[0]
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
