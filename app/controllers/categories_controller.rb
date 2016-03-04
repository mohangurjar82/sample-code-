class CategoriesController < ApplicationController
  
  def index
    @categories = MPX::Category.root_categories
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
  end

  def music
    
  end

end
