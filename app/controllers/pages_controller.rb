class PagesController < ApplicationController
  layout 'new_layout'

  def index
  	render :layout => false
  end
end
