class Preference < ActiveRecord::Base
  belongs_to :customer
  attr_accessible :customer_id, :mackerel, :monkfish, :skate, :squid, :whiting, :clams, :mussels, :oysters, :scallops
end
