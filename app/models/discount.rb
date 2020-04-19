class Discount < ApplicationRecord
 validates_presence_of :name, :percentage, :item_amount
 validates_numericality_of :percentage, greater_than: 0
 validates_numericality_of :item_amount, greater_than: 1
 belongs_to :merchant
end