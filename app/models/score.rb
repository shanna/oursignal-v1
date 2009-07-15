class Score
  include MongoMapper::Document
  key :source, String
  key :url,    String
  key :score,  Float, :default => 0
end
