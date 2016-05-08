class MediaController < ApplicationController
  
  layout 'new_layout'

  def show
    @mobile = params[:html5] || request.user_agent =~ /mobile/i
    @media = MPX::Media.find_by_number(params[:number])
    if @media.category_name =~ /Books/
      render 'media/show_book'
    elsif @media.category_name =~ /Games/
      render 'media/show_game'
    elsif @media.category_name =~ /Events/
      @results = Events.where("start_date < ? AND end_date > ? AND media_id = ?", Time.now, Time.now, @media.number)
      if @results.first.nil?
        @hasCurrentEvent = false
      else
        @hasCurrentEvent = true
        @currentEvent = @results.first
      end
      @results = Events.where("end_date > ? AND media_id = ?", Time.now, @media.number).order(:start_date).limit(1)
      if @results.first.nil?
        @hasNextEvent = false
      else
        @hasNextEvent = true
        @nextEvent = @results.first
      end
      render 'media/show_event'
    else
      current_user.push_media_to_history(@media.number) if current_user.present?
      
      if @media.is_a_game
        render 'media/new/show_game'
      else 
        render 'media/new/show'
      end
    end
  end
end
