class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = current_user.merchants[0]
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
