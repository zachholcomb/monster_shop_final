class Merchant::ItemOrdersController < ApplicationController
  def update
    item_order = ItemOrder.find(params[:id])
    fulfill(item_order)
    redirect_to "/merchant/orders/#{item_order.order_id}"
  end
  
  private
  
  def fulfill(item_order)
    new_inventory = item_order.item.sell_stock(item_order.quantity)
    item_order.update(status: 1)
    item_order.item.update(inventory: new_inventory)
    flash[:notice] = "#{item_order.item.name} was succesfully fulfilled!"
  end
end