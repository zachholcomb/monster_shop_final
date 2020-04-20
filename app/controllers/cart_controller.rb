class CartController < ApplicationController
  before_action :restrict_admin
  
  def add_item
    item = find_item
    cart.add_item(item.id.to_s)
    add_item_success(item)
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    empty_success
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    remove_item_success
  end

  def increase_quantity
    if cart.out_of_stock?(params[:item_id])
      flash[:error] = "Unable to add item! Inventory has reached 0."
    else
      cart.inc_qty(params[:item_id])
    end
    redirect_to cart_path
  end

  def decrease_quantity
    cart.dec_qty(params[:item_id])
    if cart.decrease_removal?(params[:item_id])
      return remove_item 
    end
    redirect_to cart_path
  end

  private
  def restrict_admin
    render file: "/public/404" if current_admin?
  end

  def find_item
    Item.find(params[:item_id])
  end

  def add_item_success(item)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def empty_success
    flash[:success] = "Cart successfully emptied"
    redirect_to '/cart'
  end

  def remove_item_success
    flash[:success] = "Item removed from cart"
    redirect_to '/cart'
  end
end
