require 'theplatform'
module MPX
  class Account
    class << self
      @@endpoint = 'https://identity.auth.theplatform.com/idm/web'
      @@params = { schema: '1.0', form: 'json' }

      def identity(params)
        ThePlatform::Identity.token(
          username: "mpx/#{params[:email]}",
          password: params[:password],
          schema: '1.1', form: 'json'
        )
      end
  
      def info(token)
        url = "#{@@endpoint}/Self/getSelf?" + @@params.merge(token: token).to_query
        OpenStruct.new(JSON.parse(HTTParty.get(url).body)['getSelfResponse'])
      end
    end
  end

end