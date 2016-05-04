class ProductsController < ApplicationController
  before_filter :authenticate_user!

  layout 'new_layout'
  
  def index
    @products = Product.where(available: true)
    @additional_products = []

    @json_products = @products.map { |p| [p.id, p.slice(:title, :price)] }.to_h

    @skip_javascript = true
  end

end
