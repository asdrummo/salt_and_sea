class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin
  def index
    @users = User.where(:email != nil).order('id DESC')
    @page_users = @users.paginate(:page => params[:page], :per_page => 15)
    @paginate = true
    if params[:all] == 'true'
      @page_users = @users
      @paginate = false
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end
  
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end
  
  def edit
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @customer = Customer.find(:user_id => @user.id)
    
    if @customer != nil
      @customer = Customer.find(:user_id => @user.id)
      @lineitems = LineItems.where(:customer_id => @customer.id)
      @lineitems.each do |item|
      item.destroy
      end
      @cart = Cart.where(:customer_id => @customer.id)
      @cart.each do |cart|
        cart.destroy
      end
      @orders = Order.where(:customer_id => @customer.id)
      @orders.each do |order|
        order.destroy
      end
      @customer.destroy
    end
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end
  
end
