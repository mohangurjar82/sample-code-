class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: :destroy

  def create
    if params[:user] && params[:user][:promo_code].present?
      user = User::Promo.find_or_create_by_code(params[:user][:promo_code])
      if user.present?
        sign_in(user, bypass: true)
        redirect_to categories_path and return
      end
    end
    super
  end

  private

  def after_sign_in_path_for(resource)
    set_flash
    categories_path
  end

  def set_flash
    flash[:notice] = nil
    if resource.start_trial_date.nil?
      session[:show_trial] = true 
    else
      if current_user.trial_expired?
        flash[:alert] = "Your 7 Days Free Trial has been expired. Please subscribe to continue."
      else
        flash[:notice] = 'You are currently on "7 Days Free Trial". You have full access to all media for 7 Days.'
      end
    end
  end
end