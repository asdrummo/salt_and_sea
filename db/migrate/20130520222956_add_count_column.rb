class AddCountColumn < ActiveRecord::Migration
  def up
    add_column :customers, :order_count, :integer
  end

  def down
    drop_column :customers, :order_count
  end
end
