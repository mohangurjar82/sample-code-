class ProductsController < ApplicationController
  
  def index
    @products = MPX::Product.all
  end

end
