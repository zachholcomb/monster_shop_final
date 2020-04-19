class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = current_user.merchants.first.discounts
  end
end