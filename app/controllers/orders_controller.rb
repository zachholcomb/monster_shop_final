class OrdersController <ApplicationController
  def index
    user = User.find(session[:user])
    @orders = user.orders
  end

  def new
    if !current_user
      flash[:error] = 'Unable to checkout, please log in or register.'
      redirect_to '/cart'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = create_user_order
    if order.save
      create_item_orders(order)
      finalize_order
    else
      reject_order
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def create_item_orders(order)
    cart.items.each do |item, quantity|
      if check_item_for_discounts(item, quantity)
        create_item_order(order, item, quantity)
      else 
        create_discounted_item_order(order, item, quantity)
      end
    end
  end

  def create_item_order(order, item, quantity)
    order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
  end

  def create_discounted_item_order(order, item, quantity)
    order.item_orders.create({
      item: item,
      quantity: quantity,
      price: item.apply_discount((item.select_highest_discount(quantity).percentage))
    })
  end

  def check_item_for_discounts(item, quantity)
    item.no_discounts?(quantity)
  end

  def create_user_order
    user = User.find(session[:user])
    order = user.orders.create(order_params)
  end
  
  def finalize_order
    session.delete(:cart)
    flash[:success] = "Your order was successfully created"
    redirect_to "/profile/orders"
  end

  def reject_order
    flash[:error] = "Please complete address form to create an order."
    render :new
  end
end
