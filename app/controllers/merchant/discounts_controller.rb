class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = current_user.merchants.first.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end
end