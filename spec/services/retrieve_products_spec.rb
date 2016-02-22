require 'rails_helper'

RSpec.describe RetrieveProducts, type: :service do
  describe '.build' do
    it 'inits, using HTTParty' do
      expect(RetrieveProducts).to receive(:new).with(HTTParty).and_call_original
      expect(RetrieveProducts.build).to be_a(RetrieveProducts)
    end
  end

  describe '#call' do

    context 'remote', :vcr do
      it 'gets products' do
        expect(Product).to receive(:find_or_initialize_by).exactly(11).times.and_call_original
        
        result = RetrieveProducts.build.call

        expect(result).to be_products_retrieved
      end
    end

    it 'handles exception from HTTParty' do
      http = double
      allow(http).to receive(:get).and_raise('Error')

      result = RetrieveProducts.new(http).call
      
      expect(result).not_to be_products_retrieved
      expect(result.error_message).not_to be_nil
    end
    
    it 'creates product with items' do
      entry = {"id"=>"http://data.product.theplatform.com/product/data/Product/22230892",
        "title"=>"Theory of Everything",
        "longDescription"=>"In the 1960s, Cambridge University...",
        "images"=>{"uncategorized"=> [{"mediaFileId"=>"http://data.media2.theplatform.com/media/data/MediaFile/373829667", "height"=>1200, "width"=>800, "url"=>"http://someurl.jpg"}]},
        "scopes"=>[{"scopeId"=>"http://data.media2.theplatform.com/media/data/Media/373829666", "id"=>"http://Media/373829666",
          "guid"=>"0E3E367D-715D-134E-5AC0-4185DBD26398",
          "title"=>"Theory of Everything",
          "description"=>"scope desc",
          "fulfillmentStatus"=>"fulfillable"}]}
      http = double
      result = double
      allow(result).to receive(:parsed_response).and_return('entries' => [entry], 'entryCount' => 1)
      allow(http).to receive(:get).and_return(result)
      
      product = double(id: 123)
      expect(Product).to receive(:find_or_initialize_by).with(mpxid: entry['id']).and_return(product)
      expect(product).to receive(:update_attributes).with(
        title: entry['title'],
        description: entry['longDescription'],
        images: ['http://someurl.jpg'])
      
      product_item = double(id: 234)
      expect(ProductItem).to receive(:find_or_initialize_by).with(mpxid: 'http://Media/373829666', product_id: product.id).and_return(product_item)
      expect(product_item).to receive(:update_attributes).with(
        title: 'Theory of Everything', description: 'scope desc')
      allow(product).to receive(:product_items).and_return(ProductItem)
      
      RetrieveProducts.new(http).call
    end
  end
end
