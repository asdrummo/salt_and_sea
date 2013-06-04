class AddAdmin < ActiveRecord::Migration
  def up
    add_column :users, :admin, :string
    add_column :customers, :user_id, :integer
  end

  def down
  end
end
