class CreditCard
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations

  attr_accessor :card_number, :card_name, :expiration_year, :expiration_month, :card_type
  attr_accessor :region_code, :postal_code, :country_code, :address_line1, :address_line2, :city, :full_name, :phone_number

  validates :card_number, :card_name, :expiration_year, :expiration_month, :card_type, presence: true
  validates :region_code, :postal_code, :country_code, :address_line1, :city, :full_name, :phone_number, presence: true

  def as_mpx_json
    {'properties' => mpx_attributes(true, :card_number, :card_name, :expiration_year, :expiration_month, :card_type),
    'billingAddress' => mpx_attributes(false, :region_code, :postal_code, :country_code, :address_line1, :address_line2, :city, :full_name, :phone_number)
    }
  end

  private

  def mpx_attributes(first_upper, *keys)
    keys.inject({}) do |res, key|
      res.merge(key.to_s.camelize(first_upper ? :upper : :lower) => send(key))
    end
  end
end
