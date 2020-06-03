class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def merchant_orders
    # merchant_items = Item.where(:merchant_id == id)
    # require "pry"; binding.pry
    # Order.joins(:items).where( )
    Order.joins(:items).where(:merchant_id == id, :status == "pending" ).group(:id)
    # Order.joins(:items).where(:merchant_id == id, :status == "pending" )
  end


end
