class Score
  include MongoMapper::Document
  key :source, String
  key :url,    String
  key :score,  Integer, :default => 0

  validates_presence_of :source
  validates_presence_of :url
  validates_numericality_of :score
end
