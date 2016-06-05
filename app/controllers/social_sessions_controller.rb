class SocialSessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])

    puts "##################################"
    puts "##################################"
    puts user.inspect
    puts "##################################"
    puts "##################################"
    sign_in_and_redirect user
  end
end
