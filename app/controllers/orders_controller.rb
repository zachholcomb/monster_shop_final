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
    user = User.find(session[:user])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item, quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = "Your order was successfully created"
      redirect_to "/profile/orders"
    else
      flash[:error] = "Please complete address form to create an order."
      render :new
    end
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
