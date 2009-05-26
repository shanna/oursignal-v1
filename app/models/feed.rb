class Feed
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :site, String
  property :url, String
  # property :language, String, :length => 20 # TODO: http://www.ietf.org/rfc/rfc1766.txt type?
  property :etag, String
  property :published, DateTime
  property :updated, DateTime
  has n, :items
end # Feed

