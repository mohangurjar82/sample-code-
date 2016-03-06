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
end