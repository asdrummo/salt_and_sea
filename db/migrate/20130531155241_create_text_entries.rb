class CreateTextEntries < ActiveRecord::Migration
  def change
    create_table :text_entries do |t|
      t.string :name
      t.text :entry

      t.timestamps
    end
  end
end
