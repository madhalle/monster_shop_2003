class OrdersController <ApplicationController

  def new
    unless current_user?
      flash[:notice] = "You must log in or register to complete checkout"
      redirect_to "/cart"
    end
  end

  def index
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
      flash[:notice] = "Your order has been created"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    @order = Order.find(params[:order_id])
    if order_params[:type] == "cancel"
      @order.update(:status => "cancelled")
      @order.item_orders.each do |item_order|
        item_order.update(:status => "unfulfilled")
      end
      flash[:cancel] = "Order #{@order.id} has been cancelled."
      redirect_to "/profile"
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :type)
  end
end
