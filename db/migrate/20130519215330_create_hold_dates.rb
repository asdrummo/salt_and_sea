class CreateHoldDates < ActiveRecord::Migration
  def change
    create_table :hold_dates do |t|
      t.integer :customer_id
      t.date :date
      t.timestamps
    end
  end
end
