class MPX::Product < MPX::RemoteResource
  ENDPOINT = 'http://data.product.theplatform.com/product/data/Product'.freeze
  SCHEMA = '2.5.0'.freeze
  attr_accessor :attributes

  def scopes
    @scopes ||= attributes['plproduct$scopes'].map do |scope|
      id = scope['plproduct$scopeId']
      # parse scope class from url (id)
      klass = ('MPX::' + id.split('/')[-2]).constantize rescue nil
      klass.new(id: scope['plproduct$scopeId'],
                title: scope['plproduct$title'],
                description: scope['plproduct$description']) if klass
    end.compact
  end
end
