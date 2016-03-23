class CategoriesController < ApplicationController
  
  def index
    @categories = MPX::Category.root_categories
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
    @media = @category.media(page: params[:page])
    @oan = MPX::Media.find_by_number('QGhiE_u63kJn')
    @awe = MPX::Media.find_by_number('Vzo96_F9NLg2')
  end

  def music
    
  end

end
