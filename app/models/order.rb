class Order
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations

  attr_accessor :credit_card, :product_ids
end
