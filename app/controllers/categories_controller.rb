class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  
  layout 'new_layout'

  def index
    @categories = Category.root_categories
    render 'categories/index_new', layout: 'new_layout'
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
    @oan = MPX::Media.find_by_number('1428037766')
    @awe = MPX::Media.find_by_number('147013915')
    @media = @category.media.where(:language => current_language ).page(params[:page] || 1).per(MPX::RemoteResource::PER_PAGE)
    
    render 'categories/show_new'
  end

end
