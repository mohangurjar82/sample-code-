class CategoriesController < ApplicationController
  
  def index
    @categories = MPX::Category.root_categories
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
    @media = @category.media(page: params[:page])
    @oan = MPX::Media.find_by_number('1428037766')
    @awe = MPX::Media.find_by_number('147013915')
  end

  def music
    
  end

end
