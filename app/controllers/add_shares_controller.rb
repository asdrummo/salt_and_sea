class AddSharesController < ApplicationController
  # GET /add_shares
  # GET /add_shares.json
  def index
    @add_shares = AddShare.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @add_shares }
    end
  end

  # GET /add_shares/1
  # GET /add_shares/1.json
  def show
    @add_share = AddShare.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @add_share }
    end
  end

  # GET /add_shares/new
  # GET /add_shares/new.json
  def new
    @add_share = AddShare.new
    @customer_names = Customer.all(:order => 'last_name ASC')
    @products = Product.where("id = ? OR id = ?", 1, 3)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @add_share }
    end
  end

  # GET /add_shares/1/edit
  def edit
    @add_share = AddShare.find(params[:id])
    @customer_names = Customer.all(:order => 'last_name ASC')
    @customer = Customer.find(@add_share.customer_id)
    @products = Product.where("share_type = ? OR share_type = ?", "single", "double")
    
  end

  # POST /add_shares
  # POST /add_shares.json
  def create
    @add_share = AddShare.new(params[:add_share])
    params[:add_date].each do |date|
    @add_share.date = date
    end
    respond_to do |format|
      if @add_share.save
        format.html { redirect_to @add_share, notice: 'Add share was successfully created.' }
        format.json { render json: @add_share, status: :created, location: @add_share }
      else
        format.html { render action: "new" }
        format.json { render json: @add_share.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /add_shares/1
  # PUT /add_shares/1.json
  def update
    @add_share = AddShare.find(params[:id])

    respond_to do |format|
      if @add_share.update_attributes(params[:add_share])
        format.html { redirect_to @add_share, notice: 'Add share was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @add_share.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /add_shares/1
  # DELETE /add_shares/1.json
  def destroy
    @add_share = AddShare.find(params[:id])
    @add_share.destroy

    respond_to do |format|
      format.html { redirect_to add_shares_url }
      format.json { head :no_content }
    end
  end
end
