class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def top_five
    # require "pry"; binding.pry
    # Items.joins(:orders).select("orders.item_id, count(orders.iteam_id) as count").order("count desc").group("orders.item_id")
    # Item.joins("INNER JOIN t ON t.item_id = items.id").from(ItemOrder.select("item_order.item_id, COUNT(item_order.id) as count").group("item_order.item_id").order("count DESC").limit(5), :t)
  end
end
