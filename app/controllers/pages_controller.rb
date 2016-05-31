class PagesController < ApplicationController
  layout 'n2me_layout'

  def index
  	render :layout => false
  end

  def tmp_index 
  end
end
