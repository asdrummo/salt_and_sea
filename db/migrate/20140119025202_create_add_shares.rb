class CreateAddShares < ActiveRecord::Migration
  def change
    create_table :add_shares do |t|
      t.integer :customer_id
      t.integer :customer_id
      t.integer :product_id
      t.integer :quantity
      t.date :date

      t.timestamps
    end
  end
end
