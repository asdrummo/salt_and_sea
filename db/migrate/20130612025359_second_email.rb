class SecondEmail < ActiveRecord::Migration
  def up
    add_column :customers, :email_2, :string
  end

  def down
  end
end
