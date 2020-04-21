class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders
  has_many :merchant_employees, dependent: :destroy
  has_many :users, through: :merchant_employees
  has_many :discounts

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

  def pending_orders
    orders.distinct.where(status: 0)
  end

  def deactivate_items
    items.update(active?: false)
  end

  def activate_items
    items.update(active?: true)
  end

  def items_with_default_images
    default = 'https://static.wixstatic.com/media/d8d60b_6ff8d8667db1462492d681839d85054c~mv2.png/v1/fill/w_900,h_900,al_c,q_90/file.jpg' 
    items.where(image: default)
  end
end
