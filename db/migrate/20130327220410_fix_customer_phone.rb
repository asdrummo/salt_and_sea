class FixCustomerPhone < ActiveRecord::Migration
  def up
    change_column(:customers, :country, :string)
  end

  def down

  end
end
