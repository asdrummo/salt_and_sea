class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :type
      t.string :name
      t.string :description
      t.string :option
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :stock

      t.timestamps
    end
  end
end
