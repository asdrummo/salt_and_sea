class LineItems < ActiveRecord::Migration
  def up
    create_table :line_items do |t|
      t.integer  "order_id"
      t.integer  "quantity", :limit => 8
      t.decimal  "price", :precision => 10, :scale => 2
      t.decimal  "decimal", :precision => 10, :scale => 2
      t.integer  "item_id"
      t.string   "status"
      t.string   "tracking"
      t.timestamps
  end
  end
  def down
    drop_table :line_items
  end
end
