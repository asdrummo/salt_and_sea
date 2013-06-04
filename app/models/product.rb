class Product < ActiveRecord::Base
  attr_accessible :description, :name, :option, :price, :stock, :category, :credits, :image_url
  
  def category_name
    "#{category}: #{name}"
  end
end
