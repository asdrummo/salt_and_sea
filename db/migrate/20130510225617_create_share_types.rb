class CreateShareTypes < ActiveRecord::Migration
  def change
    create_table :share_types do |t|
      t.string  "share_type"
      t.string "abbreviation"
      t.timestamps
    end
  end
end
