class ChangeItemColumns < ActiveRecord::Migration
  def up
    rename_column :customer_credits, :item_id, :product_id
    rename_column :line_items, :item_id, :product_id
  end

  def down
  end
end
