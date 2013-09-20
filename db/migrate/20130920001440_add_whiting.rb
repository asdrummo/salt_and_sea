class AddWhiting < ActiveRecord::Migration
  def up
     add_column :preferences, :whiting, :boolean
  end

  def down
  end
end
