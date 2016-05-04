class CategoriesController < ApplicationController
  
  def index
    @categories = Category.root_categories
    render 'categories/index_new', layout: 'new_layout'
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
    @oan = MPX::Media.find_by_number('1428037766')
    @awe = MPX::Media.find_by_number('147013915')
    @media = @category.media(page: params[:page]) 
    
    render 'categories/show_new', layout: 'new_layout'
  end

end
