class Score
  include DataMapper::Resource
  property :id,     DataMapper::Types::Digest::SHA1.new(:source, :url), :key => true, :nullable => false
  property :source, String, :nullable => false
  property :url,    URI, :length => 255, :nullable => false
  property :score,  Float, :default => 0

  # validates_presence_of :source
  # validates_presence_of :url
  # validates_numericality_of :score
end
