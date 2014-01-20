class Usedcreditsharetype < ActiveRecord::Migration
  def up
    add_column :used_customer_credits, :credit_type, :string 
  end

  def down
  end
end
