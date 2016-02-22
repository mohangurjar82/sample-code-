require 'rails_helper'

RSpec.describe CreateOrder, type: :service do
  describe '.build' do
    it 'inits, using HTTParty, CreateOrder::CreatePaymentInstrument' do
      expect(CreateOrder::CreatePaymentInstrument).to receive(:new).and_call_original
      expect(CreateOrder.build).to be_a(CreateOrder)
    end
  end

  describe '#call', :vcr do
    let(:user){ FactoryGirl.build :user, mpx_token: 'M6sL5oKOD4Iooxa0TClssZBCsICYwBB8' }
    let(:credit_card){ FactoryGirl.build :credit_card }
    let(:product1){ Product.create mpxid: 'http://data.product.theplatform.com/product/data/Product/22231758' }
    let(:product2){ Product.create mpxid: 'http://data.product.theplatform.com/product/data/Product/22226461' }
    let(:product_ids){ [product1.id, product2.id] }
    let(:order){ Order.new(user: user, credit_card: credit_card, product_ids: product_ids) }

    it 'creates order' do
      cpi = double
      expect(cpi).to receive(:call).with(user, credit_card)
        .and_return(double(payment_instrument_created?: true,
          id: 'http://storefront.commerce.theplatform.com/storefront/data/PaymentInstrumentInfo/31742720'))
      
      result = CreateOrder.new(HTTParty, cpi).call(user, order)
      expect(result).to be_order_created
      expect(result.id).to eq 'http://storefront.commerce.theplatform.com/storefront/data/OrderHistory/47315677'
      
      expect(order).to be_persisted
      expect(order.products).to match_array [product1, product2]
      expect(order.mpxid).to eq 'http://storefront.commerce.theplatform.com/storefront/data/OrderHistory/47315677'
    end
  end
end
