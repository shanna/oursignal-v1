class Feed
  include DataMapper::Resource
  property :id, Serial
  property :link, String, :nullable => false, :length => 250
  property :title, String, :length => 250
  # property :description, Text
  # property :language, String, :length => 20 # TODO: http://www.ietf.org/rfc/rfc1766.txt type?
  property :etag, String, :length => 250
  property :updated, DateTime
  property :freshness, DateTime
  has n, :items
end # Feed

