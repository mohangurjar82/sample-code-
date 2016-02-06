class Users::SessionsController < Devise::SessionsController

  def create
    super do |user|
      result = SigninUser.build.call sign_in_params, user

      unless result.user_signedin?
        sign_out
        throw :warden, message: result.error_message
      end
    end
  end
end