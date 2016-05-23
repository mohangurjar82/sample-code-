class SearchController < ApplicationController
  layout 'new_layout'

  def index
    query = {}
    pool = Thread.pool(2)
    if params[:category].present?
      query[:byCategoryIds] = params[:category]
      pool.process do
        @category = MPX::Category.find_by_number(params[:category])
      end
    else
      @category = MPX::Category.new(title: 'All departments')
    end
    query[:q] = params[:query] if params[:query].present?
    query[:page] = params[:page] if params[:page].present?
    pool.process do
      @media = MPX::Media.all(query)
    end
    pool.shutdown
  end
end
