class SearchController < ApplicationController
  layout 'new_layout'

  def index
    @found_media = Medium.where("title @@ ?", params[:q])
                         .page(params[:page])
  end
end
