class FixOrderCartId < ActiveRecord::Migration
  def up
    change_column :orders, :cart_id, :integer, :null => false
    change_column :orders, :customer_id, :integer, :null => false
    
  end

  def down
    change_column :orders, :cart_id, :integer
  end
end
