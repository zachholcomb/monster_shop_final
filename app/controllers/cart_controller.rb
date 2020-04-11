class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    restrict_admin
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increase_quantity
    if cart.out_of_stock?(params[:item_id])
      flash[:notice] = "Unable to add item! Inventory has reached 0."
      redirect_to cart_path
    else
      cart.inc_qty(params[:item_id])
      redirect_to cart_path
    end
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
end
