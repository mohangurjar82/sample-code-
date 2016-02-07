class MPX::Media < MPX::RemoteResource
  SCHEMA = '1.2'.freeze

  def thumbnail_url
    url = attributes['plmedia$defaultThumbnailUrl']
    return url if url.present? || fetched
    fetch['plmedia$defaultThumbnailUrl']
  end
end