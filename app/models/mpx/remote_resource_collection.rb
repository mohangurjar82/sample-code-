require 'thread/pool'

class MPX::RemoteResourceCollection < Concurrent::Array
  attr_accessor :total_entries

  def self.build(resources, klass)
    pool = Thread.pool(10)
    collection = new
    resources['entries'].each do |entry|
      pool.process do
        resource = klass.new(entry)
        resource.fetch
        collection.push resource
      end
    end
    pool.shutdown
    collection.sort_by{ |entry| entry.id }
  end
end
