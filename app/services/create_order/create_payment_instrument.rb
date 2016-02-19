class CreateOrder
  class CreatePaymentInstrument
    ENDPOINT = 'https://storefront.commerce.theplatform.com/storefront/web/Payment'

    Result = ImmutableStruct.new(:payment_instrument_created?, :invalid_token?, :error_message, :id)

    def initialize(http)
      self.http = http
    end

    def self.build
      new HTTParty
    end

    def call(user, credit_card)
      result = http.post(ENDPOINT, query: {
                'token' => user.mpx_token,
                'account' => ENV['THEPLATFORM_ACCOUNT'],
                'schema' => '1.1',
                'form' => 'json'}, body: {
                  'createPaymentInstrument' => {
                    'name' => "Pass Through Card #{Time.zone.now.nsec}",
                    'paymentConfigurationId' => ENV['THEPLATFORM_PAYMENT_CONFIGURATION_ID']
                  }.merge(credit_card.as_mpx_json)
              }.to_json, headers: { 'Content-Type' => 'application/json' }) rescue nil

      if result && (response = result.parsed_response['createPaymentInstrumentResponse'])
        Result.new(payment_instrument_created: true, id: response)
      elsif result && (response = result.parsed_response['description']) &&
            /\A(?<msg>Invalid token)\z|Exception: (?<msg>[^:]+)\z/ =~ response
        Result.new(payment_instrument_created: false, invalid_token: msg == 'Invalid token', error_message: msg)
      else
        Result.new(payment_instrument_created: false, error_message: 'Failed to create Payment Instrument')
      end
    end

    private

    attr_accessor :http
  end
end
