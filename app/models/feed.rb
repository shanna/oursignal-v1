require 'uri/sanatize'
require 'dm/types/digest'

class Feed
  include DataMapper::Resource
  property :id,             DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :title,          String, :length => 255
  property :url,            URI, :length => 255, :nullable => false, :unique_index => true
  property :etag,           String, :length => 255
  property :last_modified,  DateTime
  property :total_links,    Integer, :default => 0
  property :daily_links,    Float, :default => 0
  property :created_at,     DateTime
  property :updated_at,     DateTime

  has n, :user_feeds
  has n, :users, :through => :user_feeds, :model => 'User'
  has n, :feed_links
  has n, :links, :through => :feed_links, :constraint => :destroy!

  # TODO: Move all the update code to a mixin.

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'
  def selfupdate
    options = {
      :user_agent => USER_AGENT,
      :on_success => self.class.method(:update)
    }
    options[:if_modified_since] = last_modified.to_time unless last_modified.blank?
    options[:if_none_match]     = etag unless etag.blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, options)
    updated_at = DateTime.now
    save
  end

  def self.update(url, remote_feed)
    feed = first(:url => url) || return
    begin
      Link.update(feed, remote_feed)

      DataMapper.logger.info("feed\tupdate\t#{feed.url}")
      feed.title         = remote_feed.title
      feed.etag          = remote_feed.etag
      feed.last_modified = remote_feed.last_modified.to_datetime
      feed.total_links   = feed.links.size
      feed.daily_links   = (feed.total_links.to_f / ((feed.updated_at.to_time - feed.created_at.to_time).to_f / 1.day)).round(2)
    rescue => error
      DataMapper.logger.error("feed\terror\n#{error.message}\n#{error.backtrace}")
    ensure
      feed.updated_at = DateTime.now
      feed.save
    end
  end

  #--
  # TODO: Errors.
  def self.discover(url, content = true)
    url  = URI.sanatize(url) rescue return
    feed = first_or_new(:url => url)
    return feed unless feed.new?

    # TODO: Should be a feed validation.
    return unless URI.parse(feed.url.to_s).is_a?(URI::HTTP)

    primary = Columbus.new(feed.url).primary rescue nil
    return discover(primary.url.to_s, false) if content && primary

    feed.save && feed.selfupdate
    feed
  end
end

