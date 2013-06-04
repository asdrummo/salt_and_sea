class RenameItemsToProducts < ActiveRecord::Migration
  def up
     rename_table :items, :products
  end

  def down
  end
end
