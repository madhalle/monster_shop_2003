class ItemOrdersController < ApplicationController

  def update
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.update(status: params[:status])
    if item_order.order.all_items_fulfilled?
      item_order.order.package
    end
  end
end
