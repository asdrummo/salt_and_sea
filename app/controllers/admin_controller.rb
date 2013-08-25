class AdminController < ApplicationController
  #before_filter :current_cart, :find_customer
  before_filter :authenticate_admin
  
  def index
    
    #PRINT PAGE SETTINGS
    @black_and_white = false
    @all = true
    if params[:black_and_white]
      if params[:drop_location_id]
        @selected_location = params[:drop_location_id]
        @all = false
      end
      @black_and_white = true
      @print = 'all'
    if params[:black_and_white2]
      if params[:drop_location_id]
        @selected_location = params[:drop_location_id]
        @all = false
      end
      @black_and_white = true
       @print = 'page'
    end
    
    end
    
  ## DECLARE ALL ARRAYS
  @admin_customers = []
  @admin_users = User.admin
  @admin_user_count = 0
  @admin_users.each do |user|
    customer = Customer.find_by_user_id(user.id)
  if customer
  @admin_user_count += 1
  @admin_customers << customer
  end
  end
  
  @all_inactive_customers = []
  @low_credit_customers = []
  @this_week_active_locations = []
  @this_week_inactive_locations = []
  @weekly_hold_customers = []
  @totals = []
  @customers_active = []
  @active_customer = []
  @week1_sum, @week2_sum, @week3_sum, @week4_sum, @week5_sum, @week6_sum, @week7_sum, @week8_sum = 0, 0, 0, 0, 0, 0, 0, 0
  @week1_sum_s, @week2_sum_s, @week3_sum_s, @week4_sum_s, @week5_sum_s, @week6_sum_s, @week7_sum_s, @week8_sum_s = 0, 0, 0, 0, 0, 0, 0, 0
  
  ## DROP LOCATIONS & CUSTOMERS
  @drop_locations = DropLocation.all(:order => 'day ASC')
  @customers = Customer.all(:order => 'last_name ASC')
  @customers = (@customers - @admin_customers)
  find_zero_credit_customers
  @secondary = Customer.where("email_2 LIKE '%@%'")
  
  @preference_search = Preference.new

  ## TIME CONDITIONS
  @week1_date = Date.today.beginning_of_week #assign start of week
  @drop_locations.each do |location|
    @next_date = location.commercial_date #find next drop date for location
    time_to_merge = location.start_time #merge time with date for location
    date_to_merge = @next_date
    @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
    # check if the location is active or inactive
    @s_time = (@merged_datetime + 1.week)
    if location.processed == false
        @this_week_active_locations << location
    else
        @this_week_inactive_locations << location
    end
  end   
  ## Shift start of week to next monday if all locations have been processed
  if @this_week_active_locations == []
    @date1 = Time.now.beginning_of_week + 7.days
    @week1_date = (@week1_date + 1.week)
    @all_processed = true
  else
    @date1 = Time.now.beginning_of_week
    @all_processed = false
  end
  
  #Find customers on hold this week
  @hold_dates = HoldDate.all  
  @customers.each do |customer|
    @hold_dates.each do |date|
      if (date.customer_id == customer.id) && (date.date == @week1_date)
        @weekly_hold_customers << customer
      end
    end
  end
     

  @customers.each do |customer|
    if (DropLocation.find_by_id(customer.drop_location_id).start_date < Date.today)
      customer.credits.each do |credit| unless credit.credits_available == 0
      if (credit.credits_available >= 1) && (customer.share_type == ('single fish' || 'single shellfish' || 'single basket'))
        @active_customer << customer
      end
      if (credit.credits_available >= 2) && (customer.share_type == ('double fish' || 'double shellfish' || 'double basket'))
        @active_customer << customer 
      end
      end
      end
    end
  end
   
   ## MISC VERIABLES
   @fish_lbs_text = 'fish #s: '
   @shellfish_lbs_text = 'shellfish #s: ' 
   @fishy = ""
   
   ## PREFERENCE SEARCH
   if params[:preference]
     preference_check
   end
  end
  
  def put_on_hold
    @location = DropLocation.find(params[:id])
    @customers = Customer.where(:drop_location_id => params[:id])
    @exists = false
    date = params[:date]
    @customers.each do |customer|
     customer.hold_dates.each do |existing_date|
          if existing_date.date.strftime('%Y-%m-%d') == date
             @exists = true
          end
      end
       if @exists == false
         HoldDate.new(:customer_id => customer.id, :date => date).save
        end
        @exists = false
    end
     flash[:notice] = 'Date Put on Hold'
       redirect_to(:back) 
  end
  
  def mark_as_processed
    @location = DropLocation.find(params[:id])
    @processed = false
    @location.processed_locations.each do |pl|
      if pl.date.strftime('%Y-%m-%d') == Date.today.beginning_of_week.strftime('%Y-%m-%d')
        @processed = true
      end
    end
    if @processed == false
      ProcessedLocation.new(:drop_location_id => params[:id], :date => Date.today.beginning_of_week.strftime('%Y-%m-%d')).save
      flash[:notice] = @location.name + ' Processed'
    else
    flash[:alert] = @location.name + ' is already processed'
    end
    redirect_to(:back)
  end

  
  def get_start_date(location_id)
    drop_location = DropLocation.find_by_id(location_id)
    @next_date = drop_location.commercial_date
    time_to_merge = drop_location.start_time 
    date_to_merge = @next_date
    @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
    if drop_location.start_date < Date.today
      if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@merged_datetime - 7.days)
        @date =  @selected_location.commercial_date
      else
        @date = (@selected_location.commercial_date + 1.week)
      end
    else
     @date =  drop_location.start_date
    end
  end
  
  def find_zero_credit_customers
    @customers_without_credits = []
    @fish_credits = 0
    @shellfish_credits = 0
    @basket_credits = 0
    Customer.all.each do |customer|
      customer.credits.each do |credit|
        if Product.find(credit.product_id).category == 'fish'
          @fish_credits += credit.credits_available
        elsif Product.find(credit.product_id).category == 'shellfish'
          @shellfish_credits += credit.credits_available
        elsif Product.find(credit.product_id).category == 'basket'
          @basket_credits += credit.credits_available
        end
      end
      @credit_sum = (@fish_credits + @shellfish_credits + @basket_credits)
      if @credit_sum == 0
        @customers_without_credits << customer
      elsif  ((@credit_sum > 0) && (@credit_sum < 2)) && ((customer.share_type == 'single fish') || (customer.share_type == 'single shellfish') || (customer.share_type == 'single basket'))
           @low_credit_customers << customer
      elsif ((@credit_sum > 0) && (@credit_sum < 4)) && (customer.share_type == ('double fish' || 'double shellfish' || 'double basket' || 'single fish + single shellfish' || 'single fish + double shellfish' || 'single fish + single basket' || 'single fish + double basket' || 'double fish + single shellfish'))
              @low_credit_customers << customer
      end
       @fish_credits = 0
       @shellfish_credits = 0
      @basket_credits = 0
    end
    
  end
  
  def low_credit_notifications
    @customers = Customer.all
    @low_credit_customers = []
    low_credit_check
    @low_credit_customers.each do |customer|
      CustomerOrderMailer.low_credit_notification(customer).deliver unless customer.invalid?      
    end
    flash[:notice] = 'Notifications Sent'
     redirect_to(:back)
  end
  
  def preference_check
    @customer_fish_prefs = []
     @drop_location_customers = Customer.where(:drop_location_id => params[:location_id])
     @drop_location_customers.each do |customer|
     
     if params[:preference][:skate] == "1"
         if customer.preference && (customer.preference.skate == false)
           @customer_fish_prefs << customer
           @fishy = "Skate"
        end   
    elsif params[:preference][:squid] == "1"
       if customer.preference && (customer.preference.squid == false)
         @customer_fish_prefs << customer
         @fishy = "Squid"
      end    
    elsif params[:preference][:mackerel] == "1"
       if customer.preference && (customer.preference.mackerel == false)
         @customer_fish_prefs << customer
         @fishy = "Mackerel"
      end    
    elsif params[:preference][:monkfish] == "1"
       if customer.preference && (customer.preference.monkfish == false)
         @customer_fish_prefs << customer
         @fishy = "Monkfish"
      end   
   elsif params[:preference][:clams] == "1"
       if customer.preference && (customer.preference.clams == false)
         @customer_fish_prefs << customer
         @fishy = "Clams"
      end   
  elsif params[:preference][:mussels] == "1"
     if customer.preference && (customer.preference.mussels == false)
       @customer_fish_prefs << customer
       @fishy = "Mussels"
    end    
  elsif params[:preference][:oysters] == "1"
     if customer.preference && (customer.preference.oysters == false)
       @customer_fish_prefs << customer
       @fishy = "Oysters"
    end    
  elsif params[:preference][:scallops] == "1"
     if customer.preference && (customer.preference.scallops == false)
       @customer_fish_prefs << customer
       @fishy = "Scallops"
    end 
    end
  end
  end
  
  
  def membership
    @start_date = (Date.today - 2.months)
    @orders = Order.where("created_at >= :time", {:time => @start_date})
    @member_emails = []
  end
  
end
