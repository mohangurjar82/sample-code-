class MediaController < ApplicationController
  
  def show
    @mobile = request.user_agent. =~ /mobile/i
    @media = MPX::Media.find_by_number(params[:number])
    if @media.category_name == 'E-Books'
      render 'media/show_book'
    else
      render 'media/show'
    end
  end
end
