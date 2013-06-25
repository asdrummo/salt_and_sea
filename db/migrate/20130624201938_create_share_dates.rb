class CreateShareDates < ActiveRecord::Migration
  def change
    create_table :share_dates do |t|
      t.integer :customer_id
      t.date :date

      t.timestamps
    end
  end
end
