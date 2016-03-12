class MPX::ResourceService

  def initialize(endpoint, schema, token = ENV['MPX_TOKEN'])
    @endpoint = endpoint
    @schema = schema
    @token = token
  end

  def fetch(options = {})
    options.merge! form: 'json', schema: @schema, token: @token
    full_url = "#{@endpoint}?" + options.to_query
    response = Rails.cache.fetch(full_url, expires_in: 5.minutes) do
      response = HTTParty.get(full_url).body
    end
    Oj.load(response)
  end

  def self.create_resource(klass, attributes)
    payload = { "$xmlns": {
                  "media": "http://search.yahoo.com/mrss/",
                  "pl": "http://xml.theplatform.com/data/object",
                  "plmedia": klass::IDENTITY
                }
              }
    payload.merge! attributes.merge(ownerId: ENV['THEPLATFORM_ACCOUNT'])
    url = klass::ENDPOINT + '?' + { token: ENV['MPX_TOKEN'], schema: klass::SCHEMA, form: 'json' }.to_query
    response = HTTParty.post(
      url, body: payload.to_json,
      headers: { 'Content-Type' => 'text/plain; charset=utf-8' }
    )
    Oj.load(response.body)
  end
end