class ProductsController < ApplicationController
  
  def index
    @products = Product.all.to_a
    # TODO: remove next line after demo products wil be deleted
    @products.delete_if{|p| p.product_items.detect{|pi| pi.media? }.nil? }
  end

end
