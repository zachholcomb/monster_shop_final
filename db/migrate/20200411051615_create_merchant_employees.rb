class CreateMerchantEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :merchant_employees do |t|
      t.references :merchant, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
