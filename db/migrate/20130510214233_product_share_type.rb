class ProductShareType < ActiveRecord::Migration
  def up
    add_column :products, :share_type, :string
  end

  def down
  end
end
