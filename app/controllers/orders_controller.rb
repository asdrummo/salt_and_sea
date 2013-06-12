class OrdersController < ApplicationController
  before_filter :find_customer
  before_filter :authenticate_admin, :only => [:pay_by_check]
  
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
      if @order.purchase
        CustomerOrderMailer.order_confirmation(@order).deliver unless @order.invalid?
        CustomerOrderMailer.order_notification(@order).deliver unless @order.invalid?
        @purchased_cart = Cart.find_by_id(@order.cart_id)
        @inc_count = false
        @purchased_cart.line_items.each do |line_item|
          @product = Product.find(line_item.product_id) 
          if @product.category == ("fish" || "shellfish" || "basket")
            @inc_count = true
          end
        end
        if @inc_count = true
          @customer.order_count += 1
          @customer.save
        end
        check_active
        check_date(DropLocation.find(@customer.drop_location_id))
        if (@within_five_days == true) && (@active == false)
           @date = Time.now.beginning_of_week
           @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => @date).save
        end
        update_credits
        render :action => "success"
        #@purchased_items = line_items.where(:cart_id => @order.cart_id)
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
        @order_transaction = OrderTransaction.new(:order_id => @order.id, :action => 'purchase', :amount => @total_price, :success => '1', :authorization => 'check' )
           @order_transaction.order_id = @order.id
            @order_transaction.save
            current_cart.update_attribute(:purchased_at, Time.now)
            CustomerOrderMailer.order_confirmation(@order).deliver unless @order.invalid?
            CustomerOrderMailer.order_notification(@order).deliver unless @order.invalid?
            @purchased_cart = Cart.find_by_id(@order.cart_id)
            @inc_count = false
        @purchased_cart.line_items.each do |line_item|
          @product = Product.find(line_item.product_id) 
          if @product.category == ("fish" || "shellfish" || "basket")
            @inc_count = true
          end

          if @inc_count = true
            @customer.order_count += 1
            @customer.save
          end
        end
        if @order.save
          check_active
          check_date(DropLocation.find(@customer.drop_location_id))
          if (@within_five_days == true) && (@active == false)
             @date = Time.now.beginning_of_week
             @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => @date).save
          end
          update_credits
                render :action => "success"
                #@purchased_items = line_items.where(:cart_id => @order.cart_id)
        else
                render :action => "failure"
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