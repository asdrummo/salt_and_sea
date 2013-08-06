class StatsController < ApplicationController
before_filter :authenticate_admin
  def index
  #@orders = Order.all(:order => 'id DESC')
  @orders = Order.where('authorization IS NOT NULL').order(:id)
  @customers = Order.all(:order => 'id DESC')
  @good_orders = []
  end
end
