class ProductsController < ApplicationController
  before_filter :authenticate_user!

  layout 'new_layout'
  
  def index
    @products = Product.where(available: true)
    @additional_products = Medium.where.not(pricing_plan: nil)

    @json_products = @products.map { |p| [p.id, p.slice(:title, :price)] }.to_h

    @additional_products.each do |p|
      @json_products["a#{p.id}"] = { title: p.title, price: p.pricing_plan.price / 100.0 }
    end

    @skip_javascript = true
  end

end
