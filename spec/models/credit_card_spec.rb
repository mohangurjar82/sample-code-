require 'rails_helper'

RSpec.describe CreditCard, type: :model do
describe '#as_mpx_json' do
    it 'returns json string' do
      cc = FactoryGirl.build :credit_card
      expect(cc.as_mpx_json).to eq("properties" => {
                                      "CardNumber" => "4111111111111111",
                                      "CardName" => "John Doe",
                                      "ExpirationYear" => "2020",
                                      "ExpirationMonth" => "01",
                                      "CardType" => "Visa"
                                    },
                                   "billingAddress" => {
                                      "regionCode" => "WA",
                                      "postalCode" => "18121",
                                      "countryCode" => "US",
                                      "addressLine1" => "123 a st",
                                      "addressLine2" => "#400",
                                      "city" => "Seattle",
                                      "fullName" => "John Q Doe",
                                      "phoneNumber" => "1234567890"
                                   })
    end
  end
end
