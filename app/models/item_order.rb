class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def merchant_orders
    require "pry"; binding.pry
    Order.joins(:items).where( )
  end
end
