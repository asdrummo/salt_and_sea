class CustomerCreditsUsed < ActiveRecord::Migration
  def up
    create_table "used_customer_credits", :force => true do |t|
      t.integer  "customer_id"
      t.integer  "product_id"
      t.integer  "credits_used"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end
  end

  def down

  end
end
