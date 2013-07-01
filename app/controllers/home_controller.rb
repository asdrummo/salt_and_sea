class HomeController < ApplicationController
  before_filter :current_cart, :find_customer
  before_filter :authenticate_user!, :only => [:my_account, :show_invoice]
  
  def index
    @home = true
    @products = Product.all
    @fish_products = Product.where(:category => "fish").order('created_at ASC') 
    @shellfish_products = Product.where(:category => "shellfish").order('created_at ASC') 
    @basket_products = Product.where(:category => "basket").order('created_at ASC') 
    @accessory_products = Product.where(:category => "accessory").order('created_at ASC') 
  end

  def my_cart
    @order = Order.new
    @customers = Customer.all(:order => 'last_name ASC')
  end

  def my_account
    @user = current_user
    @eight_weeks = []
  	@date = Time.now.beginning_of_week
    @hold_date = HoldDate.new
    @share_date = ShareDate.new
    get_next_date
    if @customer != nil
      check_active(@customer)
      @credits = CustomerCredit.where(:customer_id => @customer.id)
      @orders = Order.where(:customer_id => @customer.id)
      @page_orders = @orders.paginate(:page => params[:page], :per_page => 5).order('created_at DESC') 
      @used_customer_credits = UsedCustomerCredit.where(:customer_id => @customer.id)
      @page_used_credits = @used_customer_credits.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
      @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
      if @customer.preference != nil
        @preference = @customer.preference
      else
        @preference = Preference.new(:skate => true, :squid => true, :monkfish => true, :mackerel => true, :clams => true, :mussels => true, :scallops => true, :oysters => true)
      end
    end
    if @customer == nil
      @customer_new = Customer.new
      @drop_locations = DropLocation.all
      @preference = Preference.new(:skate => true, :squid => true, :monkfish => true, :mackerel => true, :clams => true, :mussels => true, :scallops => true, :oysters => true)
    end
    
    @fish_count = 0
    @fish_credits = 0
    @shellfish_count = 0
    @shellfish_credits = 0
    @basket_count = 0
    @basket_credits = 0
  end
  
  def hold_dates
    @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
    if params[:hold_dates] == nil
      flash[:alert] = 'Please select a hold date before submitting'
       redirect_to(:action => 'my_account')
    else
    params[:hold_dates].each do |date|
      @exists = false
      @customer_hold_dates.each do |existing_date|
        if date == existing_date.date.strftime('%a %d %b %Y')
          @exists = true
        end
      end
      if @exists == false
        @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => date)
        @customer_hold_date.save
      end
    end
    flash[:notice] = 'Hold Dates Saved!'
     redirect_to(:action => 'my_account')
    end
  end
  
  def share_dates
    @customer_share_dates = ShareDate.where(:customer_id => @customer.id)
    if params[:share_dates] == nil
      flash[:alert] = 'Please select a share date before submitting'
       redirect_to(:action => 'my_account')
    else
    params[:share_dates].each do |date|
      @exists = false
      @customer_share_dates.each do |existing_date|
        if date == existing_date.date.strftime('%a %d %b %Y')
          @exists = true
        end
      end
      if @exists == false
        @customer_share_date = ShareDate.new(:customer_id => @customer.id, :date => date)
        @customer_share_date.save
      end
    end
    flash[:notice] = 'Share Dates Saved!'
     redirect_to(:action => 'my_account')
    end
  end
  
  def get_next_date
    @next_date = (@customer_drop_location.commercial_date)
    time_to_merge = @customer_drop_location.start_time 
    date_to_merge = @next_date
    @location_merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
    if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@location_merged_datetime - 7.days)
      @next_date = (@location_merged_datetime - 7.days)
    end
  end
  
  def save_customer
      @customer = Customer.new(params[:customer])
      @drop_location = DropLocation.find(params[:customer][:drop_location_id])
      check_date(@drop_location)
    if @customer.save
      @preference = Preference.new(:customer_id => @customer.id, :skate => params[:customer][:skate], :squid => params[:customer][:squid], :monkfish => params[:customer][:monkfish], :mackerel => params[:customer][:mackerel], :mussels => params[:customer][:mussels], :clams => params[:customer][:clams], :scallops => params[:customer][:scallops], :oysters => params[:customer][:oysters]).save
      #if @within_five_days == true
         #@date = Time.now.beginning_of_week
         #@customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => @date).save
      #end
      
       flash[:notice] = 'Contact Info Saved!'
       redirect_to(:back)
      else
        flash[:alert] = 'Something Went Wong' 
           redirect_to(:back)
      end
  end
  
  def check_date(location)
    @next_date = Date.commercial(Date.today.year, 1+Date.today.cweek, day_to_int(location.day))
    time_to_merge = @customer_drop_location.start_time 
    date_to_merge = @next_date
    @within_five_days = false
    @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
    if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@merged_datetime - 7.days)
      @next_date = (@merged_datetime - 7.days)
      @within_five_days = true
    end
  end
  
  def edit_customer
      get_next_date
       @orders = Order.where(:customer_id => @customer.id)
       @date = Time.now.beginning_of_week
     	 @drop_location = DropLocation.find(@customer.drop_location_id)
       if @customer.preference != nil
         @preference = @customer.preference
        else
         @preference = Preference.new(:skate => true, :squid => true, :monkfish => true, :mackerel => true, :clams => true, :mussels => true, :scallops => true, :oysters => true)
        end
      if current_user.id == @customer.user_id
          @edit_user = true
          render(params[:page])
      else
          flash[:notice] = 'Unauthorized Access'
          redirect_to(:back)
      end
  end
      
  def update_customer
    if @customer.update_attributes(params[:customer])
      if @customer.preference != nil
        @preference = @customer.preference
       else
        @preference = Preference.new
       end
       @preference.update_attributes(:customer_id => @customer.id, :skate => params[:customer][:skate], :squid => params[:customer][:squid], :monkfish => params[:customer][:monkfish], :mackerel => params[:customer][:mackerel], :mussels => params[:customer][:mussels], :clams => params[:customer][:clams], :scallops => params[:customer][:scallops], :oysters => params[:customer][:oysters])
      flash[:notice] = 'Contact Info Saved!'
      if params[:page]
        redirect_to(:action => params[:page])
      else
           redirect_to(:action => 'my_account')
      end
    end
  end     

  
  def empty_cart
    session[:cart_id] = nil
    flash[:notice] = 'Your cart is now empty'
    redirect_to(:action => 'index')
  end
  
  def checkout
    @customers = Customer.all
    @order = Order.new
    if @customer == nil
      @customer_new = Customer.new
      @drop_locations = DropLocation.all
      @preference = Preference.new(:skate => true, :squid => true, :monkfish => true, :mackerel => true, :clams => true, :mussels => true, :scallops => true, :oysters => true )
    end
    if params[:customer]
      if @new_customer.save
         #CustomerMailer.registration_confirmation(@customer).deliver
         flash[:notice] = 'Contact Info Saved!'
         render('checkout')
         else
           flash[:notice] = 'Something Went Wong, sorry!'
              render('checkout')
         end
    end

    
  end
  
  def remove_date
    HoldDate.find(params[:id]).destroy
    flash[:notice] = 'Hold Date Removed'
    redirect_to(:action => 'my_account')
  end
  
  def remove_share_date
    ShareDate.find(params[:id]).destroy
    flash[:notice] = 'Share Date Removed'
    redirect_to(:action => 'my_account')
  end
  
  def show_invoice
    @customer = Customer.find_by_user_id(current_user.id)
    @order = Order.find_by_id(params[:id])
    @order_transaction = OrderTransaction.find_by_order_id(@order.id)
    @purchased_cart = Cart.find_by_id(@order.cart_id)
    @success = false
    if params[:success]
      @success = true
    end
    if (signed_in? && (@customer.id == @order.customer_id)) || (user_signed_in? && (current_user.admin == "admin")) 

    else
      flash[:alert] = 'Permission Denied'
      redirect_to(:controller => 'home')
    end
  end
  
end
