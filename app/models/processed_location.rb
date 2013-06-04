class ProcessedLocation < ActiveRecord::Base
  attr_accessible :date, :drop_location_id
  belongs_to :drop_location
end
