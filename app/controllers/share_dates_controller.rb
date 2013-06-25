class ShareDatesController < ApplicationController
  # GET /share_dates
  # GET /share_dates.json
  def index
    @share_dates = ShareDate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @share_dates }
    end
  end

  # GET /share_dates/1
  # GET /share_dates/1.json
  def show
    @share_date = ShareDate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @share_date }
    end
  end

  # GET /share_dates/new
  # GET /share_dates/new.json
  def new
    @share_date = ShareDate.new
    @customer_names = Customer.all(:order => 'last_name ASC')
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @share_date }
    end
  end

  # GET /share_dates/1/edit
  def edit
    @share_date = ShareDate.find(params[:id])
    @customer_names = Customer.all(:order => 'last_name ASC')
    @customer = Customer.find(@share_date.customer_id)
  end

  # POST /share_dates
  # POST /share_dates.json
  def create
    @customer = Customer.find(params[:share_date][:customer_id])
    @customer_share_dates = ShareDate.where(:customer_id => @customer.id)
    params[:share_dates].each do |date|
          @customer_share_date = ShareDate.new(:customer_id => @customer.id, :date => date).save
    end
    flash[:notice] = 'Share Dates Saved!'
    respond_to do |format|
        format.html { redirect_to share_dates_path, notice: 'Share date was successfully created.' }
        format.json { render json: share_dates_path, status: :created, location: @share_date }
    end
  end


  # PUT /share_dates/1
  # PUT /share_dates/1.json
  def update
    @share_date = ShareDate.find(params[:id])
    @customer = Customer.find(@share_date.customer_id)    
    @customer_share_dates = ShareDate.where(:customer_id => @customer.id)
    @customer_share_dates.each do |date|
      date.destroy
    end
    params[:share_dates].each do |date|
        @customer_share_date = ShareDate.new(:customer_id => @customer.id, :date => date).save
    end
    respond_to do |format|
      if @share_date.update_attributes(params[:share_date])
        format.html { redirect_to share_dates_path, notice: 'Share date was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @share_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /share_dates/1
  # DELETE /share_dates/1.json
  def destroy
    @share_date = ShareDate.find(params[:id])
    @share_date.destroy
    flash[:notice] = 'Share Date Removed!'
    respond_to do |format|
      format.html { redirect_to share_dates_url }
      format.json { head :no_content }
    end
  end
end
