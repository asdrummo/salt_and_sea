class UsedCustomerCredit < ActiveRecord::Base
  belongs_to :order
  belongs_to :customer
  attr_accessible :credits_available, :customer_id, :product_id, :credits_used, :credit_type

end