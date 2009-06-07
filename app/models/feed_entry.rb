class FeedEntry
  include DataMapper::Resource
  property :feed_id, Integer, :key => true
  property :entry_id, Integer, :key => true
  belongs_to :feed
  belongs_to :entry
end # FeedEntry
