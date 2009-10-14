require 'score/normalize'
require 'score/update'

class Score
  include Score::Normalize
  include Score::Update

  include DataMapper::Resource
  property :id,         DataMapper::Types::Digest::SHA1.new(:source, :url), :key => true, :nullable => false
  property :source,     String, :nullable => false
  property :url,        URI, :length => 255, :nullable => false
  property :score,      Float, :default => 0
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_present :source
  validates_present :url

  def score=(f)
    attribute_set(:score, (f ? f.to_f.round(5) : 0))
  end
end
