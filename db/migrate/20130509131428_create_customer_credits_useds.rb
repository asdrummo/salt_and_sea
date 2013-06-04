class CreateCustomerCreditsUseds < ActiveRecord::Migration
  def change
    create_table :customer_credits_useds do |t|

      t.timestamps
    end
  end
end
