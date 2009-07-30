class User
  class Feed
    include DataMapper::Resource
    property :id,    Serial
    property :url,   URI,  :length => 255
    property :score, Float, :default => 0
  end # Feed
end # User
