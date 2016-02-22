require 'rails_helper'

RSpec.describe ProductItem, type: :model do
  describe '#media?' do
    it 'is true for Media' do
      pi = ProductItem.new mpxid: 'http://data.media2.theplatform.com/media/data/Media/373829661'
      expect(pi).to be_media
    end

    it 'is false for Subscription' do
      pi = ProductItem.new mpxid: 'http://data.product.theplatform.com/product/data/Subscription/20185841'
      expect(pi).not_to be_media
    end
  end
end
