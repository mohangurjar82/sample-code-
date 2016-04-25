class MediaController < ApplicationController
  
  def show
    @mobile = params[:html5] || request.user_agent =~ /mobile/i
    @media = MPX::Media.find_by_number(params[:number])
    if @media.category_name =~ /Books/
      render 'media/show_book'
    elsif @media.category_name =~ /Games/
      render 'media/show_game'
    else
      render 'media/new/show', layout: 'new_layout'
    end
  end
end
