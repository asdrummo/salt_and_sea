class CustomerHoldDate < ActiveRecord::Migration
  def up
    add_column :customers, :hold_date, :date
  end

  def down
    remove_column :customers, :hold_date, :date
  end
end
