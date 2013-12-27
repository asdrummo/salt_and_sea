class HoldDatesController < ApplicationController
    before_filter :authenticate_admin
    
  # GET /hold_dates
  # GET /hold_dates.json
  def index
   # @hold_dates = HoldDate.all(:order => 'created_at DESC').uniq
    @hold_dates = HoldDate.where(:id == true).order('id DESC').uniq
    @page_hold_dates = @hold_dates.paginate(:page => params[:page], :per_page => 30)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hold_dates }
    end
  end

  # GET /hold_dates/1
  # GET /hold_dates/1.json
  def show
    @hold_date = HoldDate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hold_date }
    end
  end

  # GET /hold_dates/new
  # GET /hold_dates/new.json
  def new
    @hold_date = HoldDate.new
    @customer_names = Customer.all(:order => 'last_name ASC')
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hold_date }
    end
  end

  # GET /hold_dates/1/edit
  def edit
    @hold_date = HoldDate.find(params[:id])
    @customer = Customer.find(@hold_date.customer_id)
    @customer_names = Customer.all(:order => 'last_name ASC')
  end

  # POST /hold_dates
  # POST /hold_dates.json
  def create
    @customer = Customer.find(params[:hold_date][:customer_id])
    @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
    @exists = false
    params[:hold_dates].each do |date|
      @customer_hold_dates.each do |existing_date|
        if existing_date.date == date.to_date
          @exists = true
        end
      end
      if @exists == false
        @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => date).save
      end
      @exists = false
    end
  
    respond_to do |format|
        format.html { redirect_to hold_dates_path, notice: 'Hold date was successfully created.' }
        format.json { render json: hold_dates_path, status: :created, location: hold_dates_path }
    end
  end

  # PUT /hold_dates/1
  # PUT /hold_dates/1.json
  def update
    @hold_date = HoldDate.find(params[:id])
    @customer = Customer.find(@hold_date.customer_id)    
    @customer_hold_dates = HoldDate.where(:customer_id => @customer.id)
    @customer_hold_dates.each do |date|
      date.destroy
    end
    params[:hold_dates].each do |date|
        @customer_hold_date = HoldDate.new(:customer_id => @customer.id, :date => date).save
    end
    respond_to do |format|
      if @hold_date.update_attributes(params[:hold_date])
        format.html { redirect_to hold_dates_path, notice: 'Hold date was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hold_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hold_dates/1
  # DELETE /hold_dates/1.json
  def destroy
    @hold_date = HoldDate.find(params[:id])
    @hold_date.destroy
    flash[:notice] = 'Hold Date Removed!'
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
