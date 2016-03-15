class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_categories

  def load_categories
    @root_categories = MPX::Category.root_categories.map do |cat|
      cat unless cat.title =~ /books/i
    end.compact
    @categories = MPX::Category.all
  end
end
