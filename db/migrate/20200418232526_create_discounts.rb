class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :percentage
      t.integer :item_amount

      t.timestamps
    end
  end
end
