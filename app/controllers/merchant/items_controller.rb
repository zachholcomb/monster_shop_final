class Merchant::ItemsController < ApplicationController
  before_action :require_merchant

  def index
    @items = current_user.merchants[0].items
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
