class CreateOrder
  ENDPOINT = 'https://storefront.commerce.theplatform.com/storefront/web/Checkout'

  Result = ImmutableStruct.new(:order_created?, :invalid_token?, :error_message, :id)

  def initialize(http, create_payment_instrument)
    self.http = http
    self.create_payment_instrument = create_payment_instrument
  end

  def self.build
    new HTTParty, CreatePaymentInstrument.build
  end

  def call(user, order)
    pi_result = create_payment_instrument.call(user, order.credit_card)

    unless pi_result.payment_instrument_created?
      if pi_result.invalid_token?
        Result.new(order_created: false, invalid_token: true, error_message: 'Relogin required')
      else
        Result.new(order_created: false, error_message: pi_result.error_message)
      end
    else
      result = http.post(ENDPOINT, query: {
                'token' => user.mpx_token,
                'account' => ENV['THEPLATFORM_ACCOUNT'],
                'schema' => '1.4',
                'form' => 'json'}, body: {
                  "oneStepOrder" => {
                    "paymentRef" => pi_result.id,
                    "purchaseItemInfos" => order.products.map{|p| {
                        "productId" => p.mpxid,
                        "quantity" => 1,
                        "currency" => "USD"}},
                    "properties" => {"TestOrder" => true}
                  }
                }.to_json, headers: { 'Content-Type' => 'application/json' }) rescue nil

      if result && (response = result.parsed_response['oneStepOrderResponse']) && response['status'] == 'Completed'
        order.save
        Result.new(order_created: true, id: response['providerOrderRef'])
      else
        Result.new(order_created: false, error_message: 'Failed to create Order')
      end
    end
  end

  private

  attr_accessor :http, :create_payment_instrument

end
