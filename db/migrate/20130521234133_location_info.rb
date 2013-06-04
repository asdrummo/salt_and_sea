class LocationInfo < ActiveRecord::Migration
  def up
    add_column :drop_locations, :info, :text
  end

  def down
  end
end
