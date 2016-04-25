class Users::RegistrationsController < Devise::RegistrationsController
  layout proc{ |controller| user_signed_in? ? 'application' : 'devise' }
  
  def profile
    redirect_to new_user_session_path and return if current_user.blank?
    @products = Product.all

    render 'users/registrations/profile', layout: 'new_layout'
  end

  # POST /resource
  def create
    self.resource = CreateUser.build.call(sign_up_params)
    
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
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
