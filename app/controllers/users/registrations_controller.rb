class Users::RegistrationsController < Devise::RegistrationsController
  layout proc{ |controller| user_signed_in? ? 'new_layout' : 'devise' }

  skip_before_filter :verify_authenticity_token, :only => [:update_avatar]
  respond_to :json

  def profile
    redirect_to new_user_session_path and return if current_user.blank?
    @subscriptions = current_user.subscriptions

    render 'users/registrations/profile'
  end


  def after_sign_up_path_for(resource)
    all_stations = Station.all
    all_stations.each do |st|
      current_user.stations << st
    end

    preference_settings = Preference.new(initial_time: 'now', station_filter: 'broadcast,cable,community', time_span: 3, grid_height: 7)
    current_user.preference = preference_settings 

    products_path
  end


  def update_avatar
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource_updated = update_resource(resource, account_update_params)
    render :layout => false
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)

  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar_option, :avatar)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
