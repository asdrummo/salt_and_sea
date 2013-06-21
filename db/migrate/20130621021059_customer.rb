class Customer < ActiveRecord::Migration
  def up
    add_column :customers, :first_drop, :date
  end

  def down
  end
end
