class ItemsCredits < ActiveRecord::Migration
  def up
    add_column :items, :credits, :integer
  end

  def down
  end
end
