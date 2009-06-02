class FeedEntry
  include DataMapper::Resource
  belongs_to :feed
  belongs_to :entry
end # FeedEntry
