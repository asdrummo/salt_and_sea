class LineItemsController < ApplicationController
    
  def create
    @product = Product.find(params[:product_id])
    existing_product = @cart.line_items.find {|item| @product.id == item.product_id}
      if existing_product
        @new_quantity = (existing_product.quantity += 1)
        existing_product.update_attributes(:quantity => @new_quantity)
      else
        @line_item = LineItem.create!(:cart => current_cart, :product => @product, :quantity => 1, :price => @product.price)
      end
      flash[:notice] = "Added #{@product.name} to cart."
      redirect_to(:back)
  end
  
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy 
    flash[:notice] = "Removed product from cart."
    redirect_to(:back)
  end

end
