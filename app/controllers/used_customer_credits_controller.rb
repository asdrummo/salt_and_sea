class UsedCustomerCreditsController < ApplicationController
    before_filter :authenticate_admin
  def index
    
    @used_credits = UsedCustomerCredit.where(:id != nil).order('id DESC')
    @page_used_credits = @used_credits.paginate(:page => params[:page], :per_page => 30)
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
