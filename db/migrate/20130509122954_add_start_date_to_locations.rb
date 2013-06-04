class AddStartDateToLocations < ActiveRecord::Migration
  def change
    add_column :drop_locations, :start_date, :date
  end
end
