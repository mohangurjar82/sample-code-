class MPX::Media < MPX::RemoteResource
  ENDPOINT = 'http://data.media2.theplatform.com/media/data/Media'.freeze
  SCHEMA = '1.2'.freeze

  def file_url
    files = attributes['media$content']
    return files.first['plfile$url'] if files.present?
    nil
  end

  def thumbnail_url
    url = attributes['plmedia$defaultThumbnailUrl']
    return url if url.present? || fetched
    fetch['plmedia$defaultThumbnailUrl']
  end

  def category_name
    if attributes['media$categories'].size > 0
      attributes['media$categories'].first['media$name']
    else
      'TV'
    end
  end
end