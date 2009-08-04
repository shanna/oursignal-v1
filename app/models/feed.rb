require 'uri/sanatize'
require 'dm/types/digest'

class Feed
  include DataMapper::Resource
  property :id,            DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :title,         String, :length => 255
  property :url,           URI, :length => 255, :nullable => false, :unique_index => true
  property :etag,          String, :length => 255
  property :last_modified, DateTime
  property :created_at,    DateTime
  property :updated_at,    DateTime

  has n, :user_feeds
  has n, :users, :through => :user_feeds, :model => 'User'
  has n, :links, :through => Resource, :constraint => :destroy!

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
      DataMapper.logger.info("feed\tupdate\t#{feed.url}")
      feed.title         = remote_feed.title
      feed.etag          = remote_feed.etag
      feed.last_modified = remote_feed.last_modified.to_datetime
    ensure
      feed.updated_at = DateTime.now
      feed.save && Link.update(feed, remote_feed)
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

