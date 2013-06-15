class CustomerOrderMailer < ActionMailer::Base
  default :from => "orders@saltandsea.me"
  
  def order_confirmation(order)
      attachments["banner_marketplace.jpg"] = File.read("#{Rails.root}/app/assets/images/banner_marketplace.jpg")
      @purchased_cart = Cart.find_by_id(order.cart_id)
  	  @accessory, @share = false, false
      @customer = Customer.find(order.customer_id)
      @location = DropLocation.find(@customer.drop_location_id)
      @order = order
      @account = (root_url + "home/my_account")
      get_next_date
      mail(:to => "#{@customer.first_name} <#{@customer.email}>", :subject => ("Salt + Sea Order #" + order.id.to_s))
  end
  
  def order_notification(order)
      @purchased_cart = Cart.find_by_id(order.cart_id)
  	  @accessory, @share = false, false
      @customer = Customer.find(order.customer_id)
      @location = DropLocation.find(@customer.drop_location_id)
      @order = order
      get_next_date
      mail(:to => "justinecsimon@gmail.com", :subject => ("Order #" + order.id.to_s))
  end
  
  def low_credit_notification(customer)
    attachments["banner_marketplace.jpg"] = File.read("#{Rails.root}/app/assets/images/banner_marketplace.jpg")
      @customer = customer
      @share_type = customer.share_type
      mail(:to => "#{@customer.first_name} <#{@customer.email}>", :subject => ("Salt + Sea Low Shares Notice"))
  end

  def get_next_date
     @next_date = Date.commercial(Date.today.year, 1+Date.today.cweek, @location.day.to_i)
      time_to_merge = @location.start_time 
      date_to_merge = @next_date
      @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
      if @location.start_date < Date.today
        if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@merged_datetime - 7.days)
          @date = Date.commercial(Date.today.year, Date.today.cweek, @location.day.to_i)
        else
          @date = Date.commercial(Date.today.year, 1+Date.today.cweek, @location.day.to_i)
        end
      else
       @date =  @location.start_date
      end
      if (Date.today + 5.days) > @date
        @date = @date + 7.days
      end
  end
end