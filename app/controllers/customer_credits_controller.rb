class CustomerCreditsController < ApplicationController
  before_filter :authenticate_admin
  # GET /customer_credits
  # GET /customer_credits.json
  def index
    if params[:id]
      @customer_names = Customer.find_by_id(params[:id])
      @customer_credits = CustomerCredit.where(:customer_id => params[:id])
    else  
      @customer_names = Customer.all
      @customer_credits = CustomerCredit.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customer_credits }
    end
  end
  
  def use_credit
  process_credit(params[:id])
  flash[:notice] = 'Credit Processed'
  redirect_to(:back)
  end
  
  def use_credit_all
    customers = Customer.where(:drop_location_id => params[:id])
    @exists = false
    @share_date_exists = false
    customers.each do |customer|
      customer.hold_dates.each do |existing_date|
        if existing_date.date.strftime('%Y-%m-%d') == params[:date]
          @exists = true
        end
      end
      customer.share_dates.each do |existing_share_date|
        if existing_share_date.date.strftime('%Y-%m-%d') == params[:date]
          @share_date_exists = true
        end
      end
      if @exists == false
        process_credit(customer.id)
      end
      if @share_date_exists == true
        process_credit(customer.id)
      end
      @exists = false
    end
    flash[:notice] = 'Customers Processed'
    redirect_to(:back)
  end
  
  def add_credit_all
    customers = Customer.where(:drop_location_id => params[:id])
    @exists = false
    @share_date_exists = false
    customers.each do |customer|
      customer.hold_dates.each do |existing_date|
        if existing_date.date.strftime('%Y-%m-%d') == params[:date]
          @exists = true
        end
      end
      customer.share_dates.each do |existing_share_date|
        if existing_share_date.date.strftime('%Y-%m-%d') == params[:date]
          @share_date_exists = true
        end
      end
      if @exists == false
        unprocess_credit(customer.id)
      end
      if @share_date_exists == true
        unprocess_credit(customer.id)
      end
      @exists = false
    end
    flash[:notice] = 'Customers UnProcessed'
    redirect_to(:back)
  end

  
  def process_credit(customer_id)
    customer_credits = CustomerCredit.where(:customer_id => customer_id)
    customer = Customer.find_by_id(customer_id)
    @single_fish_stop = false
    @double_fish_stop = false
    @single_shellfish_stop = false
    @double_shellfish_stop = false
    @double_basket_stop = false
      customer_credits.each do |credit|
        category = Product.find(credit.product_id).category
        if credit.credits_available > 0
          unless @single_fish_stop == true
            if (customer.share_type == "single fish") && (category == "fish")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_fish_stop = true
            elsif (customer.share_type == "single fish + single shellfish") && (category == "fish")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_fish_stop = true
            elsif (customer.share_type == "single fish + single basket") && (category == "fish")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_fish_stop = true
            end
          end

          unless @single_shelfish_stop == true
            if (customer.share_type == "single shellfish") && (category == "shellfish")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_shelfish_stop = true
            elsif (customer.share_type == "single fish + single shellfish") && (category == "shellfish")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_shelfish_stop = true
            elsif (customer.share_type == "double fish + single shellfish") && (category == "shellfish")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_shelfish_stop = true    
            end
          end

          unless @single_basket_stop == true      
            if (customer.share_type == "single basket") && (category == "basket")
              credit.credits_available -= 1
              add_used_credit(credit, customer_id, 1)
              @single_basket_stop = true
              elsif (customer.share_type == "single fish + single basket") && (category == "basket")
                credit.credits_available -= 1
                add_used_credit(credit, customer_id, 1)
                @single_basket_stop = true            
            end
          end
          credit.save
        end
        
        if credit.credits_available > 1
          unless @double_fish_stop == true
            if (customer.share_type == "double fish") && (category == "fish")
              credit.credits_available -= 2 
              add_used_credit(credit, customer_id, 2)
              @double_fish_stop = true
            elsif (customer.share_type == "double fish + double shellfish") && (category == "fish")
              credit.credits_available -= 2 
              add_used_credit(credit, customer_id, 2)
              @double_fish_stop = true
            elsif (customer.share_type == "double fish + single shellfish") && (category == "fish")
              credit.credits_available -= 2 
              add_used_credit(credit, customer_id, 2)
              @double_fish_stop = true
            end
          end
          
          unless @double_shellfish_stop == true
            if (customer.share_type == "double shellfish") && (category == "shellfish")
              credit.credits_available -= 2
              add_used_credit(credit, customer_id, 2) 
              @double_shellfish_stop = true
            elsif (customer.share_type == "double fish + double shellfish") && (category == "shellfish")
              credit.credits_available -= 2
              add_used_credit(credit, customer_id, 2) 
              @double_shellfish_stop = true
            end
          end
          
          unless @double_basket_stop == true
            if (customer.share_type == "double basket") && (category == "basket")
              credit.credits_available -= 2
              add_used_credit(credit, customer_id, 2) 
              @double_basket_stop = true
            end
          end
          credit.save
        end 
    end
  end
########UNPROCESS########
  def unprocess_credit(customer_id)
    customer_credits = CustomerCredit.where(:customer_id => customer_id)
    customer = Customer.find_by_id(customer_id)
    @single_fish_stop = false
    @double_fish_stop = false
    @single_shellfish_stop = false
    @double_shellfish_stop = false
    @double_basket_stop = false
      customer_credits.each do |credit|
        category = Product.find(credit.product_id).category
        if credit.credits_available > 0
          unless @single_fish_stop == true
            if (customer.share_type == "single fish") && (category == "fish")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_fish_stop = true
            elsif (customer.share_type == "single fish + single shellfish") && (category == "fish")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_fish_stop = true
            elsif (customer.share_type == "single fish + single basket") && (category == "fish")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_fish_stop = true
            end
          end
### 
          unless @single_shelfish_stop == true
            if (customer.share_type == "single shellfish") && (category == "shellfish")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_shelfish_stop = true
            elsif (customer.share_type == "single fish + single shellfish") && (category == "shellfish")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_shelfish_stop = true
            elsif (customer.share_type == "double fish + single shellfish") && (category == "shellfish")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_shelfish_stop = true    
            end
          end

          unless @single_basket_stop == true      
            if (customer.share_type == "single basket") && (category == "basket")
              credit.credits_available += 1
              remove_used_credit(credit, customer_id, 1)
              @single_basket_stop = true
              elsif (customer.share_type == "single fish + single basket") && (category == "basket")
                credit.credits_available += 1
                remove_used_credit(credit, customer_id, 1)
                @single_basket_stop = true            
            end
          end
          credit.save
        end
        
        if credit.credits_available > 1
          unless @double_fish_stop == true
            if (customer.share_type == "double fish") && (category == "fish")
              credit.credits_available += 2 
              remove_used_credit(credit, customer_id, 2)
              @double_fish_stop = true
            elsif (customer.share_type == "double fish + double shellfish") && (category == "fish")
              credit.credits_available += 2 
              remove_used_credit(credit, customer_id, 2)
              @double_fish_stop = true
            elsif (customer.share_type == "double fish + single shellfish") && (category == "fish")
              credit.credits_available += 2 
              remove_used_credit(credit, customer_id, 2)
              @double_fish_stop = true
            end
          end
          
          unless @double_shellfish_stop == true
            if (customer.share_type == "double shellfish") && (category == "shellfish")
              credit.credits_available += 2
              remove_used_credit(credit, customer_id, 2) 
              @double_shellfish_stop = true
            elsif (customer.share_type == "double fish + double shellfish") && (category == "shellfish")
              credit.credits_available += 2
              remove_used_credit(credit, customer_id, 2) 
              @double_shellfish_stop = true
            end
          end
          
          unless @double_basket_stop == true
            if (customer.share_type == "double basket") && (category == "basket")
              credit.credits_available += 2
              remove_used_credit(credit, customer_id, 2) 
              @double_basket_stop = true
            end
          end
          credit.save
        end 
    end
  end
  
  def add_used_credit(credit, customer_id, value)
    @customer_credit_used = UsedCustomerCredit.new(:customer_id => customer_id, :product_id => credit.product_id, :credits_used => value).save
  end
  
  def remove_used_credit(credit, customer_id, value)
    @used_credit = UsedCustomerCredit.where(:customer_id => customer_id).order('created_at DESC').first
    @used_credit.destroy
  end
    
  # GET /customer_credits/1
  # GET /customer_credits/1.json
  def show
    @customer_credit = CustomerCredit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_credit }
    end
  end

  # GET /customer_credits/new
  # GET /customer_credits/new.json
  def new
    @customer_credit = CustomerCredit.new
    @customer_names = Customer.all(:order => 'last_name ASC')
    @products = Product.where("credits > 0" )
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_credit }
    end
  end

  # GET /customer_credits/1/edit
  def edit
    @customer_credit = CustomerCredit.find(params[:id])
    @customer_names = Customer.all(:order => 'last_name ASC')
    @products = Product.all
  end

  # POST /customer_credits
  # POST /customer_credits.json
  def create
    @customer_credit = CustomerCredit.new(params[:customer_credit])

    respond_to do |format|
      if @customer_credit.save
        format.html { redirect_to @customer_credit, notice: 'Customer credit was successfully created.' }
        format.json { render json: @customer_credit, status: :created, location: @customer_credit }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customer_credits/1
  # PUT /customer_credits/1.json
  def update
    @customer_credit = CustomerCredit.find(params[:id])

    respond_to do |format|
      if @customer_credit.update_attributes(params[:customer_credit])
        format.html { redirect_to @customer_credit, notice: 'Customer credit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_credits/1
  # DELETE /customer_credits/1.json
  def destroy
    @customer_credit = CustomerCredit.find(params[:id])
    @customer_credit.destroy

    respond_to do |format|
      format.html { redirect_to customer_credits_url }
      format.json { head :no_content }
    end
  end
end
