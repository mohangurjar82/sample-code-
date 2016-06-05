class SocialSessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])

    sign_in user
    redirect_to categories_path
  end
end
