class ShareDate < ActiveRecord::Base
  attr_accessible :customer_id, :date
  belongs_to :customer
end
