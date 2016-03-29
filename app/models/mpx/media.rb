class MPX::Media < MPX::RemoteResource
  ENDPOINT = 'http://data.media2.theplatform.com/media/data/Media'.freeze
  IDENTITY = 'http://xml.theplatform.com/media/data/Media'.freeze
  SCHEMA = '1.2'.freeze

  FIELDS = %w(title description author)
  ADVANCED_FIELDS = %w(eAN iSBN numberOfPages publicationDate publisherName
                       recordReference)

  def title
    attributes.title.to_s.sub(/\A\w--/, '')
  end

  def file_url
    files = attributes['media$content']
    return files.first['plfile$url'] if files.present?
    nil
  end

  def thumbnail_url
    url = attributes['plmedia$defaultThumbnailUrl']
    return url if url.present?
    fetch unless fetched
    url = attributes['plmedia$defaultThumbnailUrl']
    url.present? ? url : thumbnails.first
  end

  def thumbnails
    attributes['media$thumbnails'].map do |file|
      file['plfile$url']
    end
  end

  def category_name
    if attributes['media$categories'].size > 0
      attributes['media$categories'].first['media$name'].to_s.sub(/\A\w--/, '')
    else
      'TV'
    end
  end

  def overlay
    attributes['pl1$overlay']
  end

  def overlay_link
    attributes['pl1$overlayLink'].present? ? attributes['pl1$overlayLink'] : '#'
  end

  def category=(name)
    self.attributes['media$categories'] ||= []
    self.attributes['media$categories'].push('media$name' => name)
  end
   
  def method_missing(method, *arguments, &block)
    method_name = method.to_s.sub('=', '')
    if FIELDS.include?(method_name)
      self.attributes[method_name] = arguments.first
    elsif field = ADVANCED_FIELDS.find { |f| method_name =~ /#{f}/i }
      self.attributes["plmedia$#{field}"] = arguments.first
    else
      super(method, *arguments, &block)
    end
  end

end