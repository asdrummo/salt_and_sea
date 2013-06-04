class Item < ActiveRecord::Base
  attr_accessible :description, :name, :option, :price, :stock, :category, :credits
  
  def category_name
    "#{category}: #{name}"
  end
end
