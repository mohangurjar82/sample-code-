class MPX::RemoteResource
  extend Forwardable
  SCHEMA = '1.1'.freeze
  attr_accessor :attributes, :fetched

  def self.all(options = {})
    resources = MPX::ResourceService.new(self::ENDPOINT,
                                         self::SCHEMA).fetch(options)['entries']
    return [] unless resources
    resources.map { |r| new(r) }
  end

  def self.find_by_number(number)
    m = new(id: [self::ENDPOINT, number].join('/'))
    m.fetch && m
  end

  def initialize(params = {})
    self.attributes = OpenStruct.new(params)
  end

  def fetch
    self.fetched = true
    self.attributes = OpenStruct.new(
      MPX::ResourceService.new(id, self.class::SCHEMA).fetch
    )
  end

  def number
    id.split('/')[-1]
  end

  def save
    if id.present?
      raise 'Update not implemented'
    else
      self.attributes = OpenStruct.new MPX::ResourceService.create_resource(
        self.class, attributes.to_h
      )
    end
  end

  def_delegators :attributes, :id
  def_delegators :attributes, :title
  def_delegators :attributes, :description
end
