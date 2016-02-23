class MediaController < ApplicationController
  
  def show
    @mobile = request.user_agent. =~ /mobile/i
    @media = MPX::Media.find_by_number(params[:number])
  end

end
