class MerchantsItemsController < ApplicationController
   def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @item = Item.find(params[:item_id])
  end
end