require 'theplatform'
class Users::SessionsController < Devise::SessionsController

  def create
    user = User.find_by(email: user_params[:email])
    if user.nil? || user.mpx_token.blank?
      user = create_user(user || User.new(user_params))
    end
    
    if user.present?
      if user.valid_password?(user_params[:password]) || create_user(user)
        sign_in(user)
        redirect_to after_sign_in_path_for(user), notice: 'Signed in'
        return  
      end
    end

    flash[:alert] = 'Wrong email or password.'
    redirect_to new_user_session_path
  end

  private

  def create_user(user)
    token = get_mpx_token
    if token['signInResponse']
      user.mpx_token = token['signInResponse']['token']
      user.mpx_user_id = token['signInResponse']['userId']
      user.password_confirmation = user_params[:password] unless user.id
      user.save ? user : false
    else
      false
    end
  end

  def get_mpx_token
    ThePlatform::Identity.token(
      username: "mpx/#{user_params[:email]}",
      password: user_params[:password],
      schema: '1.1', form: 'json'
    )
  end

  def user_params
    params.require(:user).permit(:email, :password, :remember_me)
  end
end