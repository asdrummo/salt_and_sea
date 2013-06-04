class OrderTransaction < ActiveRecord::Migration
  def up
    create_table "order_transactions", :force => true do |t|
      t.integer  "order_id"
      t.string   "action"
      t.integer  "amount"
      t.boolean  "success"
      t.string   "authorization"
      t.string   "message"
      t.text     "params"
      t.datetime "created_at"
      t.datetime "updated_at"
    end 
  end

  def down
  end
end
