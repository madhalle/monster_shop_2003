class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  #orders through item_orders
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

    Order.joins(:items).where(:merchant_id == id, :status == "pending" ).group(:id)#distinct
    #specify merchant_id is on items table
    #.orders where status pending
  end


end
