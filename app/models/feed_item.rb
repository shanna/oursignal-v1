class FeedItem
  include DataMapper::Resource
  belongs_to :feed
  belongs_to :item
end # FeedItem
