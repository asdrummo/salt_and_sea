class DropLocation < ActiveRecord::Base
  attr_accessible :state, :street, :zip_code, :city, :day, :link, :name, :time, :info, :start_time, :end_time, :start_date
  belongs_to :customers
  has_many :processed_locations
  
  def time
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end
  
  
  def processed 
      @processed = false
      self.processed_locations.each do |pl|
        if pl.date.strftime('%Y-%m-%d') == Date.today.beginning_of_week.strftime('%Y-%m-%d')
          @processed = true
        end
      end
      return @processed
  end
  
  def commercial_date
    if self.day == "0" 
      @day = 7
    else
      @day = self.day
    end
    return Date.commercial(Date.today.year, Date.today.cweek, @day.to_i)
  end
  
  def display_name
    "#{name} (#{Date::ABBR_DAYNAMES[day.to_i]})"
  end
  
  def address
    "#{street}, #{city}, #{state}"
  end
  
end
