class MPX::Media < MPX::RemoteResource
  ENDPOINT = 'http://data.media2.theplatform.com/media/data/Media'.freeze
  IDENTITY = 'http://xml.theplatform.com/media/data/Media'.freeze
  SCHEMA = '1.2'.freeze

  FIELDS = %w(title description author)
  ADVANCED_FIELDS = %w(eAN iSBN numberOfPages publicationDate publisherName
                       recordReference)

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