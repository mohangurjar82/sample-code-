class ProductsController < ApplicationController
  
  def index
    @products = MPX::Product.all
    # TODO: remove next line after demo products wil be deleted
    @products.delete_if { |x| x.scopes.select{ |m| m.class.to_s == 'MPX::Media' }.size == 0 }
  end

end
