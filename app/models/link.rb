require 'uri/redirect'

class Feed
  include MongoMapper::EmbeddedDocument
  key :url,           String
  key :etag,          String
  key :last_modified, Time
end # Feed

class Link
  include MongoMapper::Document
  key :url,       String
  key :title,     String
  # key :icon, Binary
  key :referrers, Array # DBRefs
  key :score,     Float
  key :velocity,  Float
  key :feed,      ::Feed, :default => Feed.new

  # TODO: URL Type.
  def url=(url)
    uri = URI.parse(url)
    uri.extend(URI::Redirect)
    @url = uri.resolve!.to_s
  end

  validates_true_for(
    :url,
    :message => %q{You didn't enter a valid HTTP URL.},
    :logic   => lambda { URI.parse(url).is_a?(URI::HTTP)}
  )

  def to_json(options = {})
    defaults = {:only => [:url, :title, :score]}.update(options)
    super defaults
  end

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'
  def selfupdate
    opts = {
      :user_agent => USER_AGENT,
      :on_success => self.class.method(:feed_update),
    }
    opts[:if_modified_since] = feed.last_modified unless feed.last_modified.blank?
    opts[:if_none_match]     = feed.etag unless feed.etag.blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, opts)
  end

  def self.feed_update(url, remote_feed)
    link = first(:conditions => {:url => url}) || return
    # TODO: Drama! Some of these feeds are being treated as US-ASCII when they are clearly UTF-8
    # remote_feed.sanitize_entries!

    return if remote_feed.entries.empty?
    Merb.logger.info("Feed Update: #{link.url}")

    link.title              = remote_feed.title
    link.feed.url           = remote_feed.url
    link.feed.etag          = remote_feed.etag
    link.feed.last_modified = remote_feed.last_modified
    link.referrers << link.url
    link.save

    remote_feed.entries.map do |entry|
      next if first(:conditions => {:url => entry.url})
      create(
        :title     => entry.title,
        :url       => entry.url,
        :referrers => [link.url]
      )
      # TODO: Dig links out of content as well.
    end
  rescue => e
    Merb.logger.error("Feed Error (#{url}): #{e.message}\n#{e.backtrace}")
    link.updated_at = Time.now
    link.save
  end

  def self.discover(url, deep = true)
    feed = new(:url => url)
    feed.validate_only('true_for/url') # TODO: Group.
    raise MongoMapper::DocumentNotValid.new(feed) unless feed.errors.empty?

    link = first(:conditions => {:url => feed.url, :feed => {:'$ne' => {}}})
    return link if link

    if deep && primary = Columbus.new(feed.url).primary
      return discover(primary.url.to_s, false)
    end

    feed.save && feed.selfupdate
    feed
  end
end # Link

