class ItemOrdersController < ApplicationController

  def update
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.update(status: params[:status])
    item_order.item.modify_inventory({type: :decrease, quantity: item_order.quantity})

    if item_order.order.all_items_fulfilled?
      item_order.order.package
    end

    flash[:notice] = "You have fulfilled #{item_order.item.name}"
    redirect_back fallback_location: "/"
  end
end
