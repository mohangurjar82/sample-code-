class MPX::Product
  class << self
    @@endpoint = 'http://data.product.theplatform.com/product/data/Product'
    @@params = { schema: '2.5.0', form: 'json', token: ENV['MPX_TOKEN'] }

    def load
      @products ||= Oj.load(HTTParty.get(@@endpoint + '?' + @@params.to_query).body)
    end
  end
end