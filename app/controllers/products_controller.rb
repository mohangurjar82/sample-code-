class ProductsController < ApplicationController
  
  def index
    raw_products = MPX::Product.load['entries']
    @products = raw_products.map do |product|
      OpenStruct.new(
        title: product['title'],
        description: product['description'],
        items: product['plproduct$scopes'].map{ |item| fetch_resource(item) }
      )
    end
  end

  private

  # TODO: try to identify item type and load via specialized service
  def fetch_resource(item)
    url = item['plproduct$id'] + "?schema=1.1&form=json&token=#{ENV['MPX_TOKEN']}"

    raw_item = Oj.load(HTTParty.get(url).body)
    OpenStruct.new(
      title: item['plproduct$title'],
      description: item['plproduct$description'],
      image_url: raw_item['plmedia$defaultThumbnailUrl']
    )
  end
end
