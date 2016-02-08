class MediaController < ApplicationController
  
  def show
    @media = MPX::Media.find_by_number(params[:number])
  end

end
