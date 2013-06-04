class Orders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string   :invoice_number
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :customer_id
      t.string   :status
      t.integer  :shipping_id
      t.string   :express_token
      t.string   :express_payer_id


      t.timestamps
    end
  end
  def down
    drop_table :drop_locations
  end
end
