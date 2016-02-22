class MPX::ResourceService

  def initialize(endpoint, schema, token = ENV['MPX_TOKEN'])
    @endpoint = endpoint
    @schema = schema
    @token = token
  end

  def fetch(options = {})
    options.merge! form: 'json', schema: @schema, token: @token
    full_url = "#{@endpoint}?" + options.to_query
    Oj.load(HTTParty.get(full_url).body)
  end
end