class CreateDropLocations < ActiveRecord::Migration
  def change
    create_table :drop_locations do |t|
      t.string :name, :null => false, :default => ""
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :link
      t.string :day
      t.string :time

      t.timestamps
    end
  end
  def down
    drop_table :drop_locations
  end
end
