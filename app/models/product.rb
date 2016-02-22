class Product < ActiveRecord::Base
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :product_items
  
  accepts_nested_attributes_for :product_items
  
  def price
    active_pricing_tier['amounts']['USD']
  end

  def subscription_unit
    active_pricing_tier['subscriptionUnits']
  end

  private

  def active_pricing_tier
    pricing_plan['pricingTiers'].detect{|t| t['isActive']}
  end
end
