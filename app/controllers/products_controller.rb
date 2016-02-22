class ProductsController < ApplicationController
  
  def index
    @products = Product.all.to_a
  end

end
