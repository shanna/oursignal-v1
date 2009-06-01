class UserFeed
  include DataMapper::Resource
  property :heart, Integer, :default => 50
  belongs_to :user
  belongs_to :feed
end
