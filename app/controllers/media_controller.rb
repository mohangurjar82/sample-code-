class MediaController < ApplicationController
  before_action :authenticate_user!

  def show
    unless current_user.orders.any?
      redirect_to products_path
      return
    end
    @mobile = request.user_agent. =~ /mobile/i
    @media = MPX::Media.find_by_number(params[:number])
  end

end
