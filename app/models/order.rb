class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: %w( Pending Packaged Shipped Cancelled )

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def merchant_grandtotal(id)
    items.where(merchant_id: id).sum('items.price * quantity')
  end

  def self.sort_status
    self.all.order("status = 1 DESC, status = 0 DESC, status = 2 DESC, status = 3 DESC")
  end

  def total_item_quantity
    item_orders.sum(:quantity)
  end

  def merchant_order_items_count(id)
    items.where(merchant_id: id).sum(:quantity)
  end

  def status_to_packaged
    if item_orders.where(status: "unfulfilled") == []
      self.update(status: 1)
    end
  end
end
