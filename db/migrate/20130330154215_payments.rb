class Payments < ActiveRecord::Migration
  def up
    create_table "payments", :force => true do |t|
      t.integer  "amount",     :default => 1
      t.string   "token"
      t.string   "identifier"
      t.string   "payer_id"
      t.boolean  "recurring",  :default => false
      t.boolean  "digital",    :default => false
      t.boolean  "popup",      :default => false
      t.boolean  "completed",  :default => false
      t.boolean  "canceled",   :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
  end
end
