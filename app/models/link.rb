require 'uri/sanatize'

class Link
  class Score
    include MongoMapper::EmbeddedDocument
    key :score,      Float, :default => 0
    key :velocity,   Float, :default => 0
    key :updated_at, Time
  end # Score

  class Feed
    include MongoMapper::EmbeddedDocument
    key :url,           String
    key :etag,          String
    key :last_modified, Time
    key :updated_at,    Time
  end # Feed

  include MongoMapper::Document
  key :url,       String
  key :title,     String
  key :referrers, Array
  key :score,     Link::Score, :default => lambda { Link::Score.new}
  key :feed,      Link::Feed,  :default => lambda { Link::Feed.new}

  validates_true_for(
    :url,
    :message => %q{You didn't enter a valid HTTP URL.},
    :logic   => lambda { URI.parse(url).is_a?(URI::HTTP) rescue false}
  )

  def to_json(options = {})
    {:url => url, :title => title, :score => score.score}.to_json
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

    unless remote_feed.entries.empty?
      Merb.logger.info("Feed Update: #{link.url}")

      link.title              = remote_feed.title
      link.feed.url           = remote_feed.url
      link.feed.etag          = remote_feed.etag
      link.feed.last_modified = remote_feed.last_modified

      unless link.referrers.find{|url| url == link.url}
        link.referrers << link.url
      end

      Merb.logger.debug("Feed Update: #{link.url} processing #{remote_feed.entries.size} entries...")
      remote_feed.entries.map do |entry|
        Merb.logger.debug("Feed Update: #{link.url} find #{entry.url}.")
        next if first(:conditions => {:url => entry.url})

        sanatized_url = URI.sanatize(entry.url)
        Merb.logger.debug("Feed Update: #{link.url} sanatized find #{sanatized_url}.")
        next if first(:conditions => {:url => sanatized_url = URI.sanatize(entry.url)})

        Merb.logger.debug("Feed Update: #{link.url} adding entry link #{sanatized_url}.")
        create(
          :title     => entry.title,
          :url       => sanatized_url,
          :referrers => [link.url]
        )
        # TODO: Dig links out of content as well.
      end
    end
  rescue => e
    Merb.logger.error("Feed Error (#{url}): #{e.message}")
  ensure
    link.feed.updated_at = Time.now
    link.save
  end

  def self.discover(url, deep = true)
    feed = new(:url => URI.sanatize(url))
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

