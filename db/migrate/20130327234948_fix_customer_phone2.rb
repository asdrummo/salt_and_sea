class FixCustomerPhone2 < ActiveRecord::Migration
  def up
    change_column(:customers, :phone_number, :string)
  end

  def down
  end
end
