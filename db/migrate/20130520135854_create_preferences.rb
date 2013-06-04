class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.integer :customer_id
      t.boolean :squid
      t.boolean :mackerel
      t.boolean :skate
      t.boolean :monkfish

      t.timestamps
    end
  end
end
