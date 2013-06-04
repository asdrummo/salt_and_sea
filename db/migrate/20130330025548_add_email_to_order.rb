class AddEmailToOrder < ActiveRecord::Migration
  def change
    add_column(:orders, :email, :string)
    add_column(:orders, :stripe_customer_token, :string)
  end
end
