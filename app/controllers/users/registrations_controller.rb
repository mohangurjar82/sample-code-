class Users::RegistrationsController < Devise::RegistrationsController
  layout proc{ |controller| user_signed_in? ? 'new_layout' : 'devise' }
  
  def profile
    redirect_to new_user_session_path and return if current_user.blank?
    @subscriptions = current_user.subscriptions

    render 'users/registrations/profile'
  end

  def after_sign_up_path_for(resource)
    products_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
