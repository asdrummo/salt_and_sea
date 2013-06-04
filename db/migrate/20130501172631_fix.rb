class Fix < ActiveRecord::Migration
  def up
    drop_table :orders
    create_table "orders", :force => true do |t|
      t.integer  "cart_id"
      t.string   "ip_address"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "card_type"
      t.date     "card_expires_on"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "express_token"
      t.string   "express_payer_id"
    end
  end

  def down
  end
end
