class User::OrdersController < User::BaseController

  def index
    @orders = User.find(session[:user_id]).orders
  end
end
