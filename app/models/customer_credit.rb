class CustomerCredit < ActiveRecord::Base
  belongs_to :order
  belongs_to :customer
  attr_accessible :credits_available, :customer_id, :product_id, :customer_credits_used, :drop_location_id

end