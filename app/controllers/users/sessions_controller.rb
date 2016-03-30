class Users::SessionsController < Devise::SessionsController
  after_action :flash_welcome

  def create
    if params[:user] && params[:user][:promo_code].present?
      user = User::Promo.find_or_create_by_code(params[:user][:promo_code])
      if user.present?
        sign_in(user, bypass: true)
        redirect_to categories_path and return
      end
    end
    super do |user|
      result = SigninUser.build.call sign_in_params, user
      unless result.user_signedin?
        sign_out
        throw :warden, message: result.error_message
      end
    end
  end
  
  private

  def flash_welcome
    flash[:success] = "Welcome, #{current_user.email}!" if current_user.present?
  end

  def after_sign_in_path_for(resource)
    categories_path
  end
end