class Item <ApplicationRecord
  after_initialize :set_defaults
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0
  
  def set_defaults
    if self.image == ""
      self.image = 'https://static.wixstatic.com/media/d8d60b_6ff8d8667db1462492d681839d85054c~mv2.png/v1/fill/w_900,h_900,al_c,q_90/file.jpg' 
    end
  end

  def self.active_items
    where(active?: true)
  end

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.most_purchased
     joins(:item_orders)
         .select("items.*, sum(item_orders.quantity) as item_qty")
         .group("items.id")
         .order("item_qty desc")
         .limit(5)
  end

  def self.least_purchased
    left_outer_joins(:item_orders)
        .select("items.*, sum(item_orders.quantity) as item_qty")
        .group("items.id")
        .order("item_qty nulls first")
        .limit(5)
  end

  def quantity_purchased
    item_orders.sum(:quantity)
  end

  def return_stock(amount)
    self.inventory += amount
  end

  def sell_stock(amount)
    self.inventory -= amount
  end
end
