class AddShellfishPrefs < ActiveRecord::Migration
  def up
    add_column :preferences, :clams, :boolean
    add_column :preferences, :mussels, :boolean
    add_column :preferences, :oysters, :boolean
    add_column :preferences, :scallops, :boolean
  end

  def down
  end
end
