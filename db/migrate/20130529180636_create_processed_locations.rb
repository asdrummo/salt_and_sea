class CreateProcessedLocations < ActiveRecord::Migration
  def change
    create_table :processed_locations do |t|
      t.integer :drop_location_id
      t.date :date
      t.timestamps
    end
  end
end
