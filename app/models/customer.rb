class Customer < ActiveRecord::Base
  has_many :orders
  has_many :customer_credits
  has_many :used_customer_credits
  has_many :hold_dates
  has_many :share_dates
  has_many :add_shares
  has_one :drop_location
  has_one :preference
  belongs_to :user
  attr_accessible :admin, :order_count, :mussels, :oysters, :scallops, :clams, :squid, :skate, :monkfish, :mackerel, :whiting, :account_status, :city, :contact_method, :country, :drop_location_id, :first_name, :hashed_password, :last_name, :mailing_list, :phone_number, :email, :email_2, :user_id, :state, :street, :zip_code, :hold_date, :notes, :share_type, :first_drop
  attr_accessor :squid, :skate, :monkfish, :mackerel, :mussels, :oysters, :scallops, :clams, :whiting
  validates_presence_of :email, :first_name, :last_name
  scope :scoped_location, lambda { |location| where(:drop_location_id => location.id) }
  scope :scoped_new, where( "created_at > ?", (DateTime.now - 7.days))
  #scope :first_drop, where("(first_drop > ?)", (Date.today - 1.year))
  
  def self.total_on(date)
    total = 0
    Customer.all.each do |customer|
      if customer.created_at.to_date == date
        total += 1
      end
    end
    return total
  end
  
  
  def name
    "#{first_name.humanize} #{last_name.humanize}"
  end
  
  def total_credits
    credits = 0
    self.credits.each do |credit|
      credits += credit.credits_available
    end
    return credits
  end
  
  def total_used_credits
    used_credits = 0
    self.used_customer_credits.each do |credit|
      used_credits += credit.credits_used
    end
    return used_credits
  end


  
  def last_name_first
      "#{last_name.humanize}, #{first_name.humanize}"
  end
  
  def credits
    customer_credits = CustomerCredit.where(:customer_id => self.id)
  end
  
  def hold_check(date)
    @hold = false
    self.hold_dates.each do |customer_hold_date|
      if (customer_hold_date.date <= date) && ((customer_hold_date.date + 1.week) > date)
        @hold = true
      end
    end
     return @hold
  end
  
  def add_share_check(date)
    @add = []
    self.add_shares.each do |customer_add_share|
      if (customer_add_share.date <= date) && ((customer_add_share.date + 1.week) > date)
        @add << customer_add_share.id
      end
    end
     return @add
  end
  
  def return_share(id)
    @share = AddShare.find(id)
    @shares = []
    @product = Product.find(@share.product_id)
    if @product.category == "fish"
      (1..@share.quantity).each do |share|
        @shares << "X"
      end
      return @shares
    else
      (1..@share.quantity).each do |share|
        @shares << "S"
      end
      return @shares
    end
  end
  
  def share_check(date)
    @double_share = false
    self.share_dates.each do |customer_share_date|
      if (customer_share_date.date <= date) && ((customer_share_date.date + 1.week) > date)
        @double_share = true
      end
    end
     return @double_share
  end
  
  def add_fish_credits(fish)
    if (self.share_type == "single fish") || (self.share_type == "single fish + single shellfish")
    if fish > 0
    return fish += 1
    end
  elsif self.share_type == "double fish"
    if fish > 1
    return fish += 2
    end
  else
    return fish
  end
  end
  
  def add_shellfish_credits(shellfish)
    if (self.share_type == "single shellfish") || (self.share_type == "single fish + single shellfish")
      if shellfish > 0
        return shellfish += 1
      end
    elsif self.share_type == "double shellfish"
      if shellfish > 1
        return shellfish += 2
      end
    else
      return shellfish
    end
  
  end
  
  def add_basket_credits(basket)
    if self.share_type == "single basket"
    if basket > 0
    return basket += 1
    end
  elsif self.share_type == "double basket"
    if basket > 1
    return basket += 2
    end
  else
    return basket
  end
  end
  
  def subtract_fish_credits(fish)
     if self.share_type == "single fish"
     if fish > 0
     return fish -= 1
     end
   elsif self.share_type == "double fish"
     if fish > 1
     return fish -= 2
     end
   elsif  self.share_type == "single fish + single shellfish"
     if fish > 0
     return fish -= 1
     end
   else
     return fish
   end
   end



   def subtract_shellfish_credits(shellfish, date, location, all_processed)
         if (location.processed == true) && (all_processed == false)
                   week = (date + 1.week).cweek
                   if week == 53
                     week = 1
                   end
          else
                   week = date.cweek
          end
          if week.even?
                 if (self.share_type == "single shellfish")
                   if shellfish > 0
                     return shellfish -= 1
                   end
                 elsif self.share_type == "single fish + single shellfish"
                   if shellfish > 0
                     return shellfish -= 1
                   end
                 elsif self.share_type == "double shellfish"
                   if shellfish > 1
                     return shellfish -= 2
                   end
                 else
                   return shellfish
                 end
          else
           return shellfish
         end

   end

   def subtract_basket_credits(basket)
     if self.share_type == "single basket"
     if basket > 0
     return basket -= 1
     end
   elsif self.share_type == "double basket"
     if basket > 1
     return basket -= 2
     end
   else
     return basket
   end
   end
   
    
  def weekly_product(fish, shellfish, basket, s, d, location, date, all_processed)
    if (location.processed == true) && (all_processed == false)
      week = (date + 1.week).cweek
      if week == 53
        week = 1
      end
    else
      week = date.cweek
    end
    
      if week.even? == true
        @basket = "X"
        @double_basket = "XX"
        @single_shellfish = ""
        @double_shellfish = ""
        @single_fish_shellfish = "X"
      else
        @single_shellfish = "S"
        @basket = "S"
        @double_basket = "SS"
        @double_shellfish = "SS"
        @single_fish_shellfish = "XS"
      end

    
    if (fish > s) && (self.share_type == "single fish")
      return "X"
    elsif (fish > d) && (self.share_type == "double fish")
      return "XX"
    elsif ((shellfish * 2) > s) && (self.share_type == "single shellfish")
       return(@single_shellfish)
    elsif (shellfish > d) && (self.share_type == "double shellfish")
      return(@double_shellfish)
    elsif (basket > s) && (self.share_type == "single basket")
      return @basket
    elsif (basket > d) && (self.share_type == "double basket")
      return @double_basket
    elsif (fish > s) && (basket > s) && (self.share_type == "single fish + single basket")
      return ("X" + @basket)
    elsif (fish > s) && ((shellfish * 2) > s) && (self.share_type == "single fish + single shellfish")
      return @single_fish_shellfish
    elsif (fish > s) && (self.share_type == "single fish + single shellfish")
      return("X")
    elsif ((shellfish * 2) > s) && (self.share_type == "single fish + single shellfish")
      return @single_shellfish
    elsif (fish > d) && ((shellfish * 2) > s) && (self.share_type == "double fish + single shellfish")
        if week.even? == true
        return("XX + S")
        else
          return("XX")
        end
    elsif (fish > d) && ((shellfish * 2) > d) && (self.share_type == "double fish + double shellfish")
        if week.even? == true
        return("XX + SS")
        else
          return("XX")
        end
    else
      return("")
    end
  end

  def double_weekly_product(fish, shellfish, basket, s, d, location, date, all_processed)
    if (location.processed == true) && (all_processed == false)
      week = (date + 1.week).cweek
      if week == 53
        week = 1
      end
    else
      week = date.cweek
    end
    
      if week.even? == true
        @basket = "XX"
        @double_basket = "XXXX"
        @double_shellfish = ""
        @single_shellfish = "no sf"
        @single_single = "XX"
      else
        @basket = "SS"
        @double_basket = "SSSS"
        @double_shellfish = "SSSS"
        @single_shellfish = "SS"
        @single_single = "XXSS"
      end

    if (fish > s) && (self.share_type == "single fish")
      return "XX"
    elsif (fish > d) && (self.share_type == "double fish")
      return "XXXX"
    elsif ((shellfish * 2) > s) && (self.share_type == "single shellfish")
      return "SS"
    elsif ((shellfish + shellfish) > d) && (self.share_type == "double shellfish")
     return @double_shellfish
    elsif (basket > s) && (self.share_type == "single basket")
      return @basket
    elsif (basket > d) && (self.share_type == "double basket")
      return @double_basket
    elsif (fish > s) && (basket > s) && (self.share_type == "single fish + single basket")
      return ("XX" + @basket)
    elsif (fish > s) && ((shellfish * 2) > s) && (self.share_type == "single fish + single shellfish")
      return @single_single
    elsif ((shellfish * 2) > s) && (self.share_type == "single fish + single shellfish")
      return @single_shellfish
      
    elsif (fish == s) && ((shellfish * 2) > s) && (self.share_type == "single fish + single shellfish")
      return "X"     
    elsif (fish > d) && ((shellfish * 2) > s) && (self.share_type == "double fish + single shellfish")
        return("XXXX + SS")
    elsif (fish > d) && ((shellfish * 2) > d) && (self.share_type == "double fish + double shellfish")
        return("XXXX + SSSS")
    end
  end
  
end
