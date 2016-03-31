class ProductsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    all_products = Product.all
    @additional_products, @products = all_products.partition do |p|
      tags = p.pricing_plan['pricingTiers'][0]['productTags'] rescue []
      tags.find { |t| t['title'].to_s =~ /A La Carte/i }
    end
    @json_products = all_products.map { |p| [p.id, p] }.to_h
  end

end
