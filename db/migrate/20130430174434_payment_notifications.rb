class PaymentNotifications < ActiveRecord::Migration
  def up
    create_table "payment_notifications", :force => true do |t|
      t.text     "params"
      t.integer  "cart_id"
      t.string   "status"
      t.string   "transaction_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
  end
end
