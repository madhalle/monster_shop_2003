class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def unique_item_count
    items.length
  end

  def total_item_count
    item_orders.sum('quantity')
  end

  def all_items_fulfilled?
    item_orders.all? { |item_order| item_order.status == "fulfilled"}
  end

  def package
    if all_items_fulfilled?
      update(status: "packaged")
    end
  end
end
