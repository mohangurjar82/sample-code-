class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    redirect_to(root_path) if session[:product_ids].blank?

    @order = Order.new(credit_card: CreditCard.new)
  end

  def create
    cc_params = params.require(:order).require(:credit_card).permit(:card_number, :card_name, :expiration_year, :expiration_month, :card_type,
      :region_code, :postal_code, :country_code, :address_line1, :address_line2, :city, :full_name, :phone_number)
    
    @order = Order.new(credit_card: CreditCard.new(cc_params), product_ids: session[:product_ids])

    render(:new) and return unless @order.credit_card.valid?

    result = CreateOrder.build.call current_user, @order

    if result.invalid_token?
      sign_out
      redirect_to action: :new
    elsif result.order_created?
      session.delete(:product_ids)
      redirect_to root_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end
end
