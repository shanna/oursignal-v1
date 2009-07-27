require 'digest/sha1'

class UserFeed
  include MongoMapper::EmbeddedDocument
  key :url,   String
  key :score, Float
end

class User
  include MongoMapper::Document
  key :fullname, String
  key :username, String
  key :password, String
  key :email,    String
  key :openid,   String
  many :user_feeds

  def initialize(attrs = {})
    super
    self.password = attrs.fetch(:password) if attrs.include?(:password)
  end

  def password=(password)
    write_attribute('password', digest_password(password))
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

