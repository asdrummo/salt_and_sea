class AddEmailNotes < ActiveRecord::Migration
  def up
    add_column :customers, :notes, :text
    remove_column :customers, :salt
  end

  def down
  end
end
