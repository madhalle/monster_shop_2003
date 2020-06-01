class ItemOrdersController < ApplicationController

  def update
    binding.pry
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.update(status: params[:status])
  end
end
