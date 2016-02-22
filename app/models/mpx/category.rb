class MPX::Category < MPX::RemoteResource
  ENDPOINT = 'http://data.media2.theplatform.com/media/data/Category'.freeze
  SCHEMA = '1.0'.freeze

  def media
    @media ||= MPX::Media.all(byCategories: title)
  end
end