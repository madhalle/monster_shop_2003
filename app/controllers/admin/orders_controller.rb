class Admin::OrdersController < Admin::BaseController

  def index

    @sorted_orders = Order.sort_by_status
  end

end
