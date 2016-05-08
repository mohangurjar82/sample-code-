class SubscriptionsController < ApplicationController
  layout 'new_layout'

  def new
    media_ids, product_ids = params[:product_ids].partition { |x| x.start_with?('a') }
    @products = product_ids.any? ? Product.where(id: product_ids) : []
    @medias = media_ids.any? ? Media.where(id: media_ids.map{ |x| x[/[\d]+/].to_i }) : []
    @total_price = @products.map { |x| x.pricing_plan.price }.sum
    @total_price += @medias.map { |x| x.pricing_plan.price }.sum

    @subscription = Subscription.new
  end

  def create
    params[:product_ids].split(',').each do |id|
      product = Product.find(id)
      sub = Subscription.create(user_id: current_user.id, product_id: id,
                                pricing_plan_id: product.pricing_plan_id)
      product.media.each do |m|
        SubscriptionItem.create(subscription_id: sub.id, item_id: m.id, item_type: 'Medium')
      end
    end
    params[:media_ids].split(',').each do |id|
      medium = Medium.find(id)
      sub = Subscription.create(user_id: current_user.id,
                                pricing_plan_id: medium.pricing_plan_id)
      SubscriptionItem.create(subscription_id: sub.id, item_id: medium.id, item_type: 'Medium')
    end
    redirect_to '/profile#subscription'
  end
end
