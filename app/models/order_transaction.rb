class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  serialize :params
  attr_accessible :express_token, :action, :amount, :response, :order_id, :success, :authorization
  
  def response=(response)
    self.success       = response.success?
    self.authorization = response.authorization
    self.message       = response.message
    self.params        = response.params
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
    self.params        = {}
  end
end
