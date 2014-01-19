class AddShare < ActiveRecord::Base
  attr_accessible :customer_id, :customer_id, :date, :product_id, :quantity
  belongs_to :customer
  
end
