class OrdersController < ApplicationController
  before_filter :find_customer
  before_filter :authenticate_admin, :only => [:pay_by_check, :index, :show]
  
  def express
    response = EXPRESS_GATEWAY.setup_purchase(current_cart.build_order.price_in_cents,
      :ip                => request.remote_ip,
      :return_url        => new_order_url,
      :cancel_return_url => root_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def index
    @orders = Order.all(:order => 'id DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end
  
  def destroy
    @order = Order.find(params[:id])
    @cart = Cart.find_by_id(@order.cart_id)
    @line_items = LineItem.where(:cart_id => @cart.id)
    #delete order, cart, and items
    @line_items.each do |item|
      item.destroy
    end
    @cart.destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
  
  def show
    @order = Order.find_by_id(params[:id])
    @order_transaction = OrderTransaction.find_by_order_id(@order.id)
    @purchased_cart = Cart.find_by_id(@order.cart_id)
  end
  
  def new
    @order = Order.new(:express_token => params[:token])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end
  
  #def success
   # render "success"
  #end
  
  def create
    @order = current_cart.build_order(params[:order])
    @order.ip_address = request.remote_ip
    @order.customer_id = @customer.id
    if @order.save
      get_next_date
      @customer.first_drop = @date.beginning_of_week
      if @order.purchase
        unless Rails.application.config.consider_all_requests_local
        CustomerOrderMailer.order_confirmation(@order).deliver unless @order.invalid?
        CustomerOrderMailer.order_notification(@order).deliver unless @order.invalid?
        end
        check_active
        check_date(DropLocation.find(@customer.drop_location_id))
        hold_dates
        update_credits
        order_count
        redirect_to(:controller => 'home', :action => 'show_invoice', :id => @order.id, :success => true)
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end
  
  def pay_by_check
        @customer = Customer.find(params[:order][:customer_id])
        @order = current_cart.build_order(:express_token => 'NONE', :express_payer_id => 'NONE', :first_name => @customer.first_name, :last_name => @customer.last_name, :cart_id => current_cart.id)
        @order.ip_address = request.remote_ip
        @order.customer_id = @customer.id
        @total_price = (current_cart.total_price * 100)
        if @order.save
          get_next_date
          @customer.first_drop = @date.beginning_of_week
          @order_transaction = OrderTransaction.new(:order_id => @order.id, :action => 'purchase', :amount => @total_price, :success => '1', :authorization => 'check' )
             @order_transaction.order_id = @order.id
              @order_transaction.save
              current_cart.update_attribute(:purchased_at, Time.now)
              CustomerOrderMailer.order_confirmation(@order).deliver unless @order.invalid?
              CustomerOrderMailer.order_notification(@order).deliver unless @order.invalid?
          check_active
          check_date(DropLocation.find(@customer.drop_location_id))
          hold_dates
          update_credits
          order_count
                redirect_to(:controller => 'home', :action => 'show_invoice', :id => @order.id, :success => true)
        else
                redirect_to(:controller => 'orders', :action => 'failure')
        end
  end
  
  def hold_dates
    @date = DateTime.now.beginning_of_week
    if ((@within_five_days == true) && (@active == false))
       unless HoldDate.where(:customer_id => @customer.id, :date => @date).exists?
        @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => @date).save
        end
    end
    if ((@active == false) && (@within_five_days == false) && (@merged_datetime.beginning_of_week > @date))
      unless HoldDate.where(:customer_id => @customer.id, :date => @date).exists?
      @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => @date).save
      end
   end
   if ((@active == false) && (@within_five_days == true) && (@merged_datetime.beginning_of_week > @date) && (@next_date.to_date.beginning_of_week != Date.today.beginning_of_week)) 
     unless HoldDate.where(:customer_id => @customer.id, :date => (@date + 1.week)).exists?
     @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => (@date + 1.week)).save
    end
   end
  end
  
  def get_next_date
     @location = DropLocation.find(@customer.drop_location_id)
     @next_date = Date.commercial(Date.today.year, Date.today.cweek, @location.day.to_i)
      time_to_merge = @location.start_time 
      date_to_merge = @next_date
      @date = Date.commercial(Date.today.year, Date.today.cweek, @location.day.to_i)
      @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
      if @location.start_date < Date.today
        if DateTime.now.in_time_zone("Eastern Time (US & Canada)") > (@merged_datetime) #if drop has already occurred this week, adjust date to next week.
          @date = Date.commercial(Date.today.year, 1+Date.today.cweek, @location.day.to_i)
          @next_date = Date.commercial(Date.today.year, 1+Date.today.cweek, @location.day.to_i)
        else
          #@new_date = Date.commercial(Date.today.year, Date.today.cweek, @location.day.to_i)
          #@next_date = @next_date + 1.week
         # @merged_datetime = @merged_datetime + 1.week
        end
      else
       #@date =  @location.start_date
      end
      if (Date.today + 5.days) > @date
        #@date = @date + 7.days
      end
  end
  def test
    @customer = Customer.find(158)
    @location = DropLocation.find(@customer.drop_location_id)
    check_active
    check_date(DropLocation.find(@customer.drop_location_id))
    get_next_date
    #@date = Time.now.beginning_of_week
  end
  
  def order_count
    @purchased_cart = Cart.find_by_id(@order.cart_id)
    @inc_count = false
    @purchased_cart.line_items.each do |line_item|
      @product = Product.find(line_item.product_id) 
      if (@product.category == "fish") || (@product.category == "shellfish") || (@product.category == "basket")
        @inc_count = true
      end
    end
    if @inc_count == true
      @customer.order_count += 1
      @customer.save
    end    
  end
  
  def check_active
    @active = false
    @customer.credits.each do |credit|
      if credit.credits_available >= 1
        @active = true
      end
    end
  end
  
  def update_credits
    @cart.line_items.each do |item| 
      if @credits = Product.find(item.product_id).credits
        @customer_credit = CustomerCredit.new(:customer_id => @customer.id, :product_id => item.product_id, :credits_available => @credits)
        @customer_credit.save
        @share_type = Product.find(item.product_id).share_type + " " + Product.find(item.product_id).category
        @customer.update_attributes(:share_type => @share_type)
      end
    end   
  end
end