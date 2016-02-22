class CategoriesController < ApplicationController
  
  def index
    @categories = MPX::Category.all
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
  end

end
