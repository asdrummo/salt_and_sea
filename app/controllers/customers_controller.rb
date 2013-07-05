class CustomersController < ApplicationController
  before_filter :authenticate_admin

  def index
    @customers = Customer.all(:order => 'last_name ASC')
    @drop_locations = DropLocation.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @show = true
    @customer = Customer.find(params[:id])
    check_active(@customer)
    check_date(DropLocation.find(@customer.drop_location_id))
    @credits = CustomerCredit.where(:customer_id => @customer.id)
    @orders = Order.where(:customer_id => @customer.id)
    @page_orders = @orders.paginate(:page => params[:page], :per_page => 5).order('created_at DESC') 
    @used_customer_credits = UsedCustomerCredit.where(:customer_id => @customer.id)
    @page_used_credits = @used_customer_credits.paginate(:page => params[:page], :per_page => 5).order('created_at DESC') 
    
    @fish_count = 0
    @fish_credits = 0
    @shellfish_count = 0
    @shellfish_credits = 0
    @basket_count = 0
    @basket_credits = 0
    @used_customer_credits = UsedCustomerCredit.where(:customer_id => @customer.id)
    @customer_drop_location = DropLocation.find(@customer.drop_location_id)
    @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
    @eight_weeks = []
    @date = Time.now.beginning_of_week
    @hold_date = HoldDate.new
    @share_date = ShareDate.new
      if @customer.preference != nil
      @preference = @customer.preference
      else
      @preference = Preference.new(:skate => true, :squid => true, :monkfish => true, :mackerel => true, :clams => true, :mussels => true, :scallops => true, :oysters => true)
      end
      @next_date = (@customer_drop_location.commercial_date)
      time_to_merge = @customer_drop_location.start_time 
      date_to_merge = @next_date
      @location_merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
      if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@location_merged_datetime - 7.days)
        @next_date = (@location_merged_datetime - 7.days)
      end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  def hold_dates
    @customer = Customer.find(params[:hold_date][:customer_id])
    @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
    @customer_share_dates = ShareDate.where(:customer_id => @customer.id)
    params[:hold_dates].each do |date|
      @exists = false
      @customer_hold_dates.each do |existing_date|
        if date == existing_date.date.strftime('%a %d %b %Y')
          @exists = true
        end
      end
      @customer_share_dates.each do |existing_date|
        if date == existing_date.date.strftime('%a %d %b %Y')
          @exists = true
          flash[:alert] = 'Hold Date Not Saved - Cannot Be Same Week as a Double Share Date!'
        end
      end
      if @exists == false
        @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => date)
        @customer_hold_date.save
        flash[:notice] = 'Hold Dates Saved!'
      end
    end
     redirect_to(:back)
  end
  
  def share_dates
    @customer = Customer.find(params[:share_date][:customer_id])
    @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
    @customer_share_dates = ShareDate.where(:customer_id => @customer.id)
    params[:share_dates].each do |date|
      @exists = false
      @customer_share_dates.each do |existing_date|
        if date == existing_date.date.strftime('%a %d %b %Y')
          @exists = true
        end
      end
      @customer_hold_dates.each do |existing_date|
        if date == existing_date.date.strftime('%a %d %b %Y')
          @exists = true
          flash[:alert] = 'Share Date Not Saved - Cannot Be Same Week as a Hold Date!'
        end
      end
      if @exists == false
        @customer_share_date = ShareDate.new(:customer_id => @customer.id, :date => date)
        @customer_share_date.save
      end
    end
    flash[:notice] = 'Share Dates Saved!'
     redirect_to(:back)
  end
  
  def remove_date
    HoldDate.find(params[:id]).destroy
    flash[:notice] = 'Hold Date Removed'
    redirect_to(:back)
  end
  def remove_share_date
    ShareDate.find(params[:id]).destroy
    flash[:notice] = 'Share Date Removed'
    redirect_to(:action => 'my_account')
  end
  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new
    @drop_locations = DropLocation.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
    @drop_locations = DropLocation.all
    if (current_user == @customer.user_id) || (current_user.admin == 'admin')
    else
    redirect_to customer_path(@customer.id) 
    end
  end


  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(params[:customer])
    @customer.first_name = @customer.first_name.humanize
    @customer.last_name = @customer.last_name.humanize
    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])
    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        @customer.first_name = @customer.first_name.humanize
        @customer.last_name = @customer.last_name.humanize
        @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def make_admin
    @customers = Customer.all
    @drop_locations = DropLocation.all
    @customer = Customer.find(params[:id])
    @user = User.find(@customer.user_id)
    respond_to do |format|
      if @user.update_attributes(:admin => 'admin')
        format.html{ render action: "index"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @orders = Order.where(:customer_id => @customer.id)
    if @orders
      @orders.each do |order|
        @cart = Cart.find(order.cart_id)
        @cart.line_items.each do |item|
          item.destroy
          order.destroy
          
        end
        @cart.destroy
     end
   end
    #User.find(@customer.user_id).destroy
    if @customer.preference
      @customer.preference.destroy
    end
    @credit = CustomerCredit.where(:customer_id => @customer.id)
    @credit.each do |credit|
      credit.destroy
    end
    @used_credit = UsedCustomerCredit.where(:customer_id => @customer.id)
    @used_credit.each do |credit|
      credit.destroy
    end
    @hold_dates = HoldDate.where(:customer_id => @customer.id)
    @hold_dates.each do |date|
      date.destroy
    end
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end
end
