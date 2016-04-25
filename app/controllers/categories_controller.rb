class CategoriesController < ApplicationController
  
  def index
    @categories = MPX::Category.root_categories
    pool = Thread.pool(10)
    @categories.each do |category|
      pool.process do
        category.thumbnail_url.to_s
      end
      pool.process do
        category.media.to_a
      end
    end
    pool.shutdown
    render 'categories/index_new', layout: 'new_layout'
  end

  def show
    @category = MPX::Category.find_by_number(params[:id])
    pool = Thread.pool(10)
    @category.categories.each do |cat|
      pool.process do
        cat.thumbnail_url
      end
    end
    pool.process { @media = @category.media(page: params[:page]) }
    pool.process { @oan = MPX::Media.find_by_number('1428037766') }
    pool.process { @awe = MPX::Media.find_by_number('147013915') }
    pool.shutdown
    @media = @category.media(page: params[:page]) 
    @oan = MPX::Media.find_by_number('1428037766')
    @awe = MPX::Media.find_by_number('147013915')
    
    render 'categories/show_new', layout: 'new_layout'
  end

end
