class RetrieveProducts
  ENDPOINT = 'https://data.product.theplatform.com/product/data/Product/'

  Result = ImmutableStruct.new(:products_retrieved?, :error_message)

  def initialize(http)
    self.http = http
  end

  def self.build
    new HTTParty
  end

  def call
    result = http.get(ENDPOINT, query: {
              'token' => ENV['THEPLATFORM_TOKEN'],
              'schema' => '2.5.0',
              'form' => 'cjson',
              'fields' => 'id,title,longDescription,images,scopes'}) rescue nil

    if result && result.parsed_response['entryCount'].to_i > 0
      for entry in result.parsed_response['entries']
        product = Product.find_or_initialize_by(mpxid: entry['id'])
        product.update_attributes title: entry['title'],
          description: entry['longDescription'],
          images: entry['images'].values.flatten.map{|i| i['url']}
        
        product_item_ids = []
        
        for scope in entry['scopes']
          product_item = ProductItem.find_or_initialize_by(product_id: product.id,
            mpxid: scope['id'])
          product_item.update_attributes(title: scope['title'],
            description: scope['description'])
          product_item_ids << product_item.id
        end
        
        product.product_items.where('id NOT IN (?)', product_item_ids).destroy_all
      end
      Result.new(products_retrieved: true)
    else
      Result.new(products_retrieved: false, error_message: 'Failed to retrieve products')
    end
  end

  private

  attr_accessor :http
end
