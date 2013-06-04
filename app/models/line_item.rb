class LineItem < ActiveRecord::Base
  attr_accessible :cart, :product, :quantity, :price
  belongs_to :product
  #belongs_to :order
  belongs_to :cart
  
  
  def full_price
    unit_price * quantity
  end

  @status = "processing"
  
  def self.new_item_based_on(product)
    line_item = self.new
    line_item.product = product
    line_item.quantity = 1
    line_item.status = @status
    line_item.price = product.price
    return line_item
  end
  
  def self.remove_item_based_on(product)
    line_item = self.find(product)
    line_item.product = product
    line_item.status = @status
    line_item.quantity = 1
    line_item.price = product.price
    return line_item
  end
  
end
