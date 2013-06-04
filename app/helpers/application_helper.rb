module ApplicationHelper
  def resource_name
     :user
   end

   def resource
     @resource ||= User.new
   end

   def devise_mapping
     @devise_mapping ||= Devise.mappings[:user]
   end
   
   def title(page_title, show_title = true)
     @content_for_title = page_title.to_s
     @show_title = show_title
   end
   def day(customer)
     day = DropLocation.find(customer.drop_location_id).day.to_i
     if day == 0
       return 6.days
     else
       return (day.days - 1.day)
     end
   end
   
   def error_messages
     return unless object.respond_to?(:errors) && object.errors.any?

     errors_list = ""
     errors_list << @template.content_tag(:span, "There are errors!", :class => "title-error")
     errors_list << object.errors.full_messages.map { |message| @template.content_tag(:li, message) }.join("\n")

     @template.content_tag(:ul, errors_list.html_safe, :class => "error-recap round-border")
   end
   
   def check_next_date(next_date)
 		if @next_date < DateTime.now
 		  @next_date = (@next_date + 1.week)
 		end
   end
   
   def get_start_date(location_id)
     drop_location = DropLocation.find_by_id(location_id)
     @next_date = (drop_location.commercial_date + 1.week)
     time_to_merge = drop_location.start_time 
     date_to_merge = @next_date
     @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
     if drop_location.start_date < Date.today
       if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@merged_datetime - 7.days)
         @date = drop_location.commercial_date
       else
         @date =  (drop_location.commercial_date + 1.week)
       end
     else
      @date =  drop_location.start_date
     end
   end
   
   def check_start_date(location)
     if location.start_date.beginning_of_week > Date.today.beginning_of_week
         @location_next_date = location.start_date
         time_to_merge = location.start_time
         date_to_merge = @location_next_date
         @location_merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
    elsif location.day == "0"
       @location_merged_datetime = (@location_merged_datetime - 1.week)
     end
   end
      
  def check_next_date(date)
    if DateTime.now > date
      @next_date = (date + 1.week)
    end
    return @next_date
  end
  
  def check_hold_date(customer, next_date)
    @prev_hold, @prev_hold1, @prev_hold2, @prev_hold3, @prev_hold4, @prev_hold5, @prev_hold6 = false, false, false, false, false, false, false
    customer.hold_dates.order('date ASC').each do |hold_date|
      if (next_date >= hold_date.date) && (next_date < hold_date.date + 1.week)
         @location_merged_datetime = (next_date + 1.week)
         @prev_hold = true
      end 
      if ((next_date + 1.week) >= hold_date.date) && ((next_date + 1.week) < (hold_date.date + 1.week)) && (@prev_hold == true)
        @location_merged_datetime = (next_date + 2.weeks)
        @prev_hold1 = true
      end
      if ((next_date + 2.weeks) >= hold_date.date) && ((next_date + 2.weeks) < (hold_date.date + 1.week)) && (@prev_hold == true) && (@prev_hold1 == true)
        @location_merged_datetime = (next_date + 3.weeks)
        @prev_hold2 = true
      end
      if ((next_date + 3.weeks) >= hold_date.date) && ((next_date + 3.weeks) < (hold_date.date + 1.week)) && (@prev_hold == true) && (@prev_hold1 == true) && (@prev_hold2 == true)
        @location_merged_datetime = (next_date + 4.weeks)
        @prev_hold3 = true
      end
      if ((next_date + 4.weeks) >= hold_date.date) && ((next_date + 4.weeks) < (hold_date.date + 1.week)) && (@prev_hold == true) && (@prev_hold1 == true) && (@prev_hold2 == true) && (@prev_hold3 == true)
        @location_merged_datetime = (next_date + 5.weeks)
        @prev_hold4 = true
      end
      if ((next_date + 5.weeks) >= hold_date.date) && ((next_date + 5.weeks) < (hold_date.date + 1.week)) && (@prev_hold == true) && (@prev_hold1 == true) && (@prev_hold2 == true) && (@prev_hold3 == true) && (@prev_hold4 == true)
        @location_merged_datetime = (next_date + 6.weeks)
        @prev_hold5 = true
      end
      if ((next_date + 6.weeks) >= hold_date.date) && ((next_date + 6.weeks) < (hold_date.date + 1.week)) && (@prev_hold == true) && (@prev_hold1 == true) && (@prev_hold2 == true) && (@prev_hold3 == true) && (@prev_hold4 == true) && (@prev_hold5 == true)
        @location_merged_datetime = (next_date + 7.weeks)
        @prev_hold6 = true
      end
      if ((next_date + 7.weeks) >= hold_date.date) && ((next_date + 7.weeks) < (hold_date.date + 1.week)) && (@prev_hold == true) && (@prev_hold1 == true) && (@prev_hold2 == true) && (@prev_hold3 == true) && (@prev_hold4 == true) && (@prev_hold5 == true) && (@prev_hold6 == true)
        @location_merged_datetime = (next_date + 8.weeks)
      end
    end
  end
  
   def fish(array)
     @fish_lbs = 0
     array.each do |lbs| 
     	if lbs == "X"
     		@fish_lbs += 1 
     	elsif  lbs == "XS"
     		@fish_lbs += 1 
     	elsif lbs == "XX" 
     		@fish_lbs += 2
     	elsif (lbs == "XX + S") || ( lbs == "XX + SS")
     		@fish_lbs += 2
     	end
     end
     return @fish_lbs
   end
   
   def shellfish(array)
     @shellfish_lbs = 0
     array.each do |lbs| 
     	if lbs == "S"
     		@shellfish_lbs += 1 
     	elsif  lbs == "XS"
     		@shellfish_lbs += 1 
     	elsif lbs == "SS" 
     		@shellfish_lbs += 2
     	elsif (lbs == "XX + S") 
     	  @shellfish_lbs += 1
     	elsif (lbs == "XX + SS")
     		@shellfish_lbs += 2
     	end
     end
     return @shellfish_lbs
   end
   
   
   def safe_image_tag(source, options = {})
     if (source == "") || (source.nil?)
     source = "http://s3.amazonaws.com/saltandsea/default_image.jpg"
     end
     image_tag(source, options)
   end
   
  def yesno(value)
    if value == true
       return "Yes"
    else
      return "No"
    end
  end
  
  def us_states
      [
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['District of Columbia', 'DC'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Puerto Rico', 'PR'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY']
      ]
  end

end


