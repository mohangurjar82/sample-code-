class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_categories, except: :not_found

  def load_categories
    @search_categories = MPX::Category.all
    @root_categories = MPX::Category.root_categories
  end

  def not_found
    render inline: 'Page not found', status: 404
  end
end
