class User::OrdersController < User::BaseController

  def index
    @orders = User.find(session[:user_id]).orders
  end

  def show
    @order = Order.find(params[:order_id])
  end
end
