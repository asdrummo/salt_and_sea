class CreateCustomerCredits < ActiveRecord::Migration
  def change
    create_table :customer_credits do |t|
      t.integer :customer_id
      t.integer :item_id
      t.integer :credits_available

      t.timestamps
    end
  end
end
