class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_categories, except: :not_found
  before_action :detect_browser

  def load_categories
    @search_categories = [] # MPX::Category.all
    @root_categories = [] # MPX::Category.root_categories
  end

  def not_found
    render inline: 'Page not found', status: 404
  end


  private
    def detect_browser
      case request.user_agent
        when /iPad/i
          request.variant = :tablet
        when /iPhone/i
          request.variant = :phone
        when /Android/i && /mobile/i
          request.variant = :phone
        when /Android/i
          request.variant = :tablet
        when /Windows Phone/i
          request.variant = :phone
        else
          request.variant = :desktop
      end
    end

end
