class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, :null => false, :default => ""
      t.string :salt
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country, :limit => 3
      t.integer :phone_number, :limit => 10
      t.integer :drop_location_id
      t.string :account_status
      t.string :mailing_list
      t.string :contact_method

      t.timestamps
    end
  end
  def self.down
    drop_table :customers
  end
end
