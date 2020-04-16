class ItemOrdersController < ApplicationController
  def update
    order = Order.find(params[:id])
    cancel_order(order)
  end
  
  private
  def cancel_order(order)
    if params[:type] == 'cancel'
      order.update(status: 3)
      return_to_inventory(order)
      unfulfill_item_orders(order)
      flash[:success] = "Order #{order.id} has been cancelled."
    end
    redirect_to "/profile"
  end

  def unfulfill_item_orders(order)
    order.item_orders.each do |item_order|
      item_order.update(status: 0)
    end
  end

  def return_to_inventory(order)
    order.item_orders.each do |item_order|
      if item_order.status == 'fulfilled'
        item = Item.find(item_order.item_id)
        updated_inventory = item.return_stock(item_order.quantity)
        item.update(inventory: updated_inventory)
      end
    end
  end
end