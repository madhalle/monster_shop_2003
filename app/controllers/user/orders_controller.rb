class User::OrdersController < User::BaseController

  def index
    binding.pry
    @orders = Order.all
  end
end
