class ChangeItemType < ActiveRecord::Migration
  def up
    rename_column(:items, :type, :category)
  end

  def down
  end
end
