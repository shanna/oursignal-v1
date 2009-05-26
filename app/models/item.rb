class Item
  include DataMapper::Resource
  property :id, Serial
  property :feed_id, Integer
  property :link, URI, :nullable => false
  property :title, String, :length => 250
  property :description, Text, :lazy => :false
  property :published, DateTime
  belongs_to :feed
end # Item

