require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:pricing_plan){{"isTaxIncluded"=>false,"isRecurring"=>false,"pricingTiers"=>[{"absoluteStart"=>1455150720000,"absoluteEnd"=>1483160400000,"rightsIds"=>["http://data.entitlement.theplatform.com/eds/data/Rights/62384649"],"subscriptionUnits"=>"month","billingFrequency"=>0,"minimumSubscriptionPeriod"=>0,"productTagIds"=>[],"productTags"=>[],"amounts"=>{"USD"=>14.99},"isBlackout"=>false,"isActive"=>true}],"masterAgreementStartDate"=>1455080400000,"masterAgreementEndDate"=>1483160400000,"masterProductTagIds"=>[]}}
  let(:product){ Product.new pricing_plan: pricing_plan }
  
  describe '#price' do
    it 'returns active price' do
      expect(product.price).to eq 14.99
    end
  end
  
  describe '#subscription_unit' do
    it 'returns month' do
      expect(product.subscription_unit).to eq 'month'
    end
  end
end
