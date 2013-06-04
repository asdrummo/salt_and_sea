class PaymentNotification < ActiveRecord::Base
  belongs_to :cart
  serialize :params
  after_create :mark_cart_as_purchased
  
  private
  
  def mark_cart_as_purchased
    if status == "Completed" && params[:secret] == APP_CONFIG[:paypal_secret] &&
        params[:receiver_email] == APP_CONFIG[:paypal_email] &&
       # params[:mc_gross] == line_items.to_a.sum {|item| (item.quantity * item.price) } && params[:mc_currency] == "USD"
      cart.update_attribute(:purchased_at, Time.now)
    end
  end
end
