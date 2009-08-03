require 'digest/sha1'

class User
  include DataMapper::Resource
  property :id,         Serial
  property :fullname,   String, :nullable => false
  property :username,   String, :nullable => false, :length => (2..20), :format => /^[a-z0-9][a-z0-9\-]+$/i
  property :password,   String, :length => 40
  property :email,      String, :nullable => false, :length => 255, :format => :email_address
  property :openid,     String, :length => 255
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :user_feeds, UserFeed
  has n, :feeds, :through => :user_feeds, :model => 'Feed', :constraint => :destroy!

  validates_is_unique :username

  def password=(password)
    attribute_set(:password, digest_password(password))
  end

  def self.authenticate(username, password)
    user = User.new(:username => username, :password => password)
    first(:conditions => {:username => user.username, :password => user.password})
  end

  def links(limit = 50)
    results   = {}
    referrers = user_feeds.map{|feed| [feed.url, feed.score]}.to_hash

    # Find.
    Link.all(
      :conditions => {:referrers => referrers.keys, :feed => {}},
      :order      => 'score desc, created_at asc'
    ).each do |link|
      link.score.score = referrers.values_at(*link.referrers).compact.first * link.score.score
      results[link.url] = link.freeze # Make uniq by URL.
    end

    # Sort & Limit
    results = results.values.sort{|a, b| b.score.score <=> a.score.score}
    results = results.slice(0, limit)
  end

  def feed(url)
    user_feeds.find{|feed| feed.url == url}
  end

  private
    def digest_password(password)
      Digest::SHA1.hexdigest('some salt' + password.to_s)
    end
end

