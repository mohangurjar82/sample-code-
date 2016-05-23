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
    categories_path
  end
end