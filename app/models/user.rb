class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :nullable => false
  property :email, String, :nullable => false, :unique => true
  property :identity_url, String, :nullable => false, :unique => true

  has n, :user_feeds
  has n, :feeds, :through => :user_feeds

  validates_format :email, :as => :email_address
  def password_required?; false end
end

__END__
class User
  property :id, Serial
  has n, :feeds, :through => UserFeed
end

class UserFeed
  property :user_id, Integer, :key => true
  property :feed_id, Integer, :key => true
  ...
  belongs_to :user
  belongs_to :feed
end

class Feed
  property :id, Serial
  has n, :users, :through => UserFeed
end
