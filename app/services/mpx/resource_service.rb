class MPX::ResourceService

  def initialize(endpoint, schema, token = ENV['MPX_TOKEN'])
    @endpoint = endpoint
    @schema = schema
    @token = token
  end

  def fetch
    full_url = "#{@endpoint}?" + { form: 'json', schema: @schema,
                                   token: @token }.to_query
    Oj.load(HTTParty.get(full_url).body)
  end
end