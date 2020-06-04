class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def fulfill
    update(status: "fulfilled")
  end

  def self.find_by_item(item_id)
    find { |item_order| item_order.item_id == item_id}
  end
end
