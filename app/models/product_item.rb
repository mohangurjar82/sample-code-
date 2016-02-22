class ProductItem < ActiveRecord::Base
  belongs_to :product
  
  def media?
    mpxid =~ /\/Media\/\d+\z/
  end
  
  def thumbnail_url
    raw['defaultThumbnailUrl']
  end
  
  def short_mpxid
    mpxid.gsub(/\A.+\//,'') if mpxid
  end
end
