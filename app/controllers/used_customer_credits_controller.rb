class UsedCustomerCreditsController < ApplicationController
    before_filter :authenticate_admin
  def index
    @used_credits = UsedCustomerCredit.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @used_credits }
    end
  end
  
  def show
      @used_credit = UsedCustomerCredit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @used_credit }
    end
  end

  def destroy
    @used_credits = UsedCustomerCredit.find(params[:id])
    @used_credits.destroy

    respond_to do |format|
      format.html { redirect_to used_customer_credits_url }
      format.json { head :no_content }
    end
  end
end
