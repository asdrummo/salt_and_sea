class Carts < ActiveRecord::Migration
  def up
    create_table "carts", :force => true do |t|
      t.datetime "purchased_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
  end
end
