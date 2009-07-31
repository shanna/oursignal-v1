class Score
  include DataMapper::Resource
  property :id,         DataMapper::Types::Digest::SHA1.new(:source, :url), :key => true, :nullable => false
  property :source,     String, :nullable => false
  property :url,        URI, :length => 255, :nullable => false
  property :score,      Float, :default => 0
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_present :source
  validates_present :url
end
