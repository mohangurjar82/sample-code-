class MPX::RemoteResource
  extend Forwardable
  SCHEMA = '1.1'.freeze
  attr_accessor :attributes, :fetched

  def self.all
    resources = MPX::ResourceService.new(self::ENDPOINT,
                                         self::SCHEMA).fetch['entries']
    resources.map { |r| new(r) }
  end

  def self.find_by_number(number)
    m = new(id: [self::ENDPOINT, number].join('/'))
    m.fetch && m
  end

  def initialize(params)
    self.attributes = OpenStruct.new(params)
  end

  def fetch
    self.fetched = true
    self.attributes = OpenStruct.new(
      MPX::ResourceService.new(id, self.class::SCHEMA).fetch
    )
  end

  def_delegators :attributes, :id
  def_delegators :attributes, :title
  def_delegators :attributes, :description
end
