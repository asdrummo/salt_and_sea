class AddStartEndTimeToLocations < ActiveRecord::Migration
  def change
    add_column :drop_locations, :start_time, :time
    add_column :drop_locations, :end_time, :time
  end
  
  def down
  remove_column :drop_locations, :start_time
  remove_column :drop_locations, :end_time
  end
end
