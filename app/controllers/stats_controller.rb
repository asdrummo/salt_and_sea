class StatsController < ApplicationController
before_filter :authenticate_admin
  def index
  @orders = Order.all(:order => 'id DESC')
  @customers = Order.all(:order => 'id DESC')
  end
end
