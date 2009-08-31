require 'digest/sha1'

class User
  include DataMapper::Resource
  property :id,          Serial
  property :theme_id,    Integer, :nullable => false, :default => proc {Theme.first(:name => 'treemap').id rescue nil}
  property :username,    String, :nullable => false, :length => (2..20), :format => /^[a-z0-9][a-z0-9\-]+$/i
  property :password,    String, :length => 40
  property :email,       String, :nullable => false, :length => 255, :format => :email_address
  property :openid,      String, :length => 255
  property :description, String, :length => 255
  property :tags,        String, :length => 255
  property :created_at,  DateTime
  property :updated_at,  DateTime

  belongs_to :theme
  has n, :user_feeds, :constraint => :destroy!
  has n, :feeds, :through => :user_feeds

  validates_is_unique :username

  after :create do
    # Default feeds.
    {
      'http://feeds.digg.com/digg/popular.rss'    => 1,
      'http://www.reddit.com/.rss'                => 0.7,
      'http://feeds.delicious.com/v2/rss/popular' => 0.6,
      'http://news.ycombinator.com/rss'           => 0.3,
    }.map do |url, score|
      feed = Feed.discover(url) || next
      user_feeds.first_or_create({:feed => feed}, :score => score)
    end
  end

  def title
    "#{username}'s feed"
  end

  def description
    description = attribute_get(:description)
    description = %Q{#{username}'s custom oursignal.com feed.} if description.blank?
    description
  end

  def password=(password)
    attribute_set(:password, digest_password(password))
  end

  def self.authenticate(username, password)
    user = User.new(:username => username, :password => password)
    first(:conditions => {:username => user.username, :password => user.password})
  end

  #--
  # TODO: Can I speed this up a bit?
  def links(limit = 50)
    results   = {}
    referrers = user_feeds.map{|feed| [feed.feed_id, feed.score]}.to_hash
    return [] if referrers.empty?

    sql = %q{
      select
        feed_links.feed_id as feed_id,
        links.*
      from links
      inner join feed_links on links.id = feed_links.link_id
      where feed_links.feed_id in ?
    }
    repository.adapter.query(sql, referrers.keys).each do |link|
      link.score = referrers[link.feed_id] * (link.score || 0)
      if !results[link.id] || results[link.id].score > link.score
        results[link.id] = Link.new(link.attributes.except(:feed_id))
      end
    end

    # Sort & Limit
    results = results.values.sort{|a, b| b.score <=> a.score}
    results = results.slice(0, limit)
    return results if results.empty?

    max, min = results.first.score, results.last.score
    return results unless max > min

    # Re-scale scores within this context.
    scale = 1.to_f / (max - min)
    results.map do |link|
      link.score = (link.score - min) * scale
      # TODO: Scale velocity between -1..1
      link
    end
  end

  private
    def digest_password(password)
      Digest::SHA1.hexdigest('some salt' + password.to_s)
    end
end

