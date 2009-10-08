class FeedLink
  include DataMapper::Resource
  property :feed_id,  String, :key => true, :nullable => false, :length => 40
  property :link_id,  String, :key => true, :nullable => false, :length => 40
  property :url,      String, :length => 255, :index => true
  property :external, Boolean, :default => false

  belongs_to :feed
  belongs_to :link
end # FeedLink

