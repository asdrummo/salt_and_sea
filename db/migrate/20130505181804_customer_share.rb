class CustomerShare < ActiveRecord::Migration
  def up
    add_column :customers, :share_type, :string
  end

  def down
  end
end
