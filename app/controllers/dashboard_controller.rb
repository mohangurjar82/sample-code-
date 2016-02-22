class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @product_items = ProductItem.select('DISTINCT ON (product_items.id) product_items.*')
                      .joins(product: {order_items: :order})
                      .where('orders.user_id = ?', current_user)
  end
end
