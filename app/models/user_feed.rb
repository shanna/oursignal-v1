class UserFeed
  include DataMapper::Resource
  property :user_id, Integer, :key => true, :nullable => false
  property :feed_id, String,  :key => true, :nullable => false, :length => 40
  property :score,   Float, :default => 0.5, :precision => 10, :scale => 9

  belongs_to :user
  belongs_to :feed

  def to_json(options = {})
    {
      :user_id => user_id,
      :feed_id => feed_id,
      :score   => score,
      :title   => feed.title,
      :url     => feed.url,
      :domain  => feed.domain
    }.to_json
  end
end # UserFeed

