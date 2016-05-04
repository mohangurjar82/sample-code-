class Product < ActiveRecord::Base
  # has_many :order_items
  # has_many :orders, through: :order_items
  has_many :product_items

  has_many :media, through: :product_items, source: :item, source_type: Medium
  has_many :categories, through: :product_items, source: :item, source_type: Category
  
  default_scope { where(available: true) }
  
  mount_uploader :picture, PictureUploader, mount_on: :image
  
  def price
    active_pricing_tier ? active_pricing_tier['amounts']['USD'].to_f : 0.0
  end

  def subscription_unit
    active_pricing_tier['subscriptionUnits'] if active_pricing_tier
  end
  
  def as_json(options = nil)
    { price: price, id: id, title: title, description: description }
  end

  private

  def active_pricing_tier
    pricing_plan['pricingTiers'].detect{|t| t['isActive']} if pricing_plan
  end
end
