class MPX::Category < MPX::RemoteResource
  ENDPOINT = 'http://data.media2.theplatform.com/media/data/Category'.freeze
  SCHEMA = '1.0'.freeze

  def self.root_categories
    MPX::Category.all.select { |c| c.attributes['plcategory$parentId'].empty? }
  end

  def media
    @media ||= MPX::Media.all(byCategories: title)
  end

  def categories
    @categories ||= MPX::Category.all.select do |cat|
      cat.attributes['plcategory$parentId'] == id
    end
  end

  def thumbnail_url
    media.find { |m| m.thumbnail_url.present? }.try :thumbnail_url
  end
end