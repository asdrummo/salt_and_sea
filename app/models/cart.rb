class Cart < ActiveRecord::Base
  #attr_reader :products, :total_price, :line_items
  has_many :line_items
  belongs_to :order
  
  #def initialize
  #  empty_all_items
  #end
  
  def total_price
    # convert to array so it doesn't try to do sum on database directly
    @total = 0
    line_items.each do |item|
      @total = item.price
    end
    line_items.to_a.sum {|item| (item.quantity * item.price) }
  end
  
  def empty_all_items
    @products = []
    @total_price = 0.0
  end
end
  

