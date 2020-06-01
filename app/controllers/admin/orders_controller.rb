class Admin::OrdersController < Admin::BaseController

  def index
    @sorted_orders = Order.sort_by_status
  end

  # def update
  #   order = Order.find(params[:id])
  # end

  def ship
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to "/admin"
  end

end
