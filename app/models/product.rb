class Product < ActiveRecord::Base
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :product_items
  
  accepts_nested_attributes_for :product_items
end
