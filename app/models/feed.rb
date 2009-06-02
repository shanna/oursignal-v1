class Feed
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :site, String
  property :url, String
  # property :language, String, :length => 20 # TODO: http://www.ietf.org/rfc/rfc1766.txt type?
  property :etag, String
  property :published, DateTime
  property :updated, DateTime

  has n, :users, :through => UserFeed
  has n, :entries, :through => FeedEntry

  validates_present :url
  validates_with_method :url, :method => :check_feed

  # TODO: before(:destroy) remove all UserFeed and FeedItem rows refering to this feed.

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'

  def selfupdate
    opts = {
      :user_agent => USER_AGENT,
      :on_success => self.class.method(:update)
      # :on_failure
    }
    opts[:if_modified_since] = published unless published.blank?
    opts[:if_none_match] = etag unless etag.blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, opts)
  end

  def self.update(url, remote_feed)
    feed = Feed.first!(:url => url)
    feed.attributes = {
      :title     => remote_feed.title,
      :etag      => remote_feed.etag,
      :published => remote_feed.last_modified,
    }
    feed.save if feed.dirty?

    # TODO: Items.update(feed, remote_feed.entries)
  end

  private
    def discover_feed
      primary = Columbus.new(self.site).primary
      self.url = primary.nil? ? self.site : primary.url
      true
    rescue
      false
    end

    def check_feed
      if discover_feed
        true
      else
        [false, "Feed url must contain a valid RSS or Atom feed"]
      end
    end
end # Feed

