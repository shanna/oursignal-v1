require 'dm/types/digest'

class Feed
  include DataMapper::Resource
  property :id,            DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :url,           URI, :length => 255, :nullable => false
  property :etag,          String, :length => 255
  property :last_modified, DateTime
  property :created_at,    DateTime
  property :updated_at,    DateTime

  has n, :links, :through => Resource
end

