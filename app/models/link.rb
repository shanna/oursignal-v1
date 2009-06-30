class Link
  include MongoMapper::Document
  key :url,       String
  key :title,     String
  # key :icon, Binary
  key :referrers, Array # DBRefs
  key :score,     Integer
  many :scores
end # Link

class Score
  include MongoMapper::EmbeddedDocument
  key :source, String # DBRef later?
  key :score,  Integer
end # Score

