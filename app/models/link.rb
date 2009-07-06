class Score
  include MongoMapper::EmbeddedDocument
  key :source,    String # DBRef later?
  key :score,     Float
  key :updated_at, Time
end # Score

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
  key :feed,      ::Feed, :default => Feed.new
  many :scores

  # TODO: URL Type.
  def url=(url)
    @urk = URI.parse(Addressable::URI.heuristic_parse(url, {:scheme => 'http'}).normalize!).to_s
  end

  validates_true_for(
    :url,
    :message => %q{You didn't enter a valid HTTP URL.},
    :logic   => lambda { URI.parse(url).is_a?(URI::HTTP)}
  )

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'
  def selfupdate
    opts = {
      :user_agent => USER_AGENT,
      :on_success => self.class.method(:feed_update),
    }
    opts[:if_modified_since] = feed[:last_modified] unless feed.last_modified.blank?
    opts[:if_none_match]     = feed[:etag] unless feed.etag.blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, opts)
  end

  def self.feed_update(url, remote_feed)
    link = first(:url => url) || return
    remote_feed.sanitize_entries!

    link.title              = remote_feed.title
    link.feed.url           = remote_feed.url
    link.feed.etag          = remote_feed.etag
    link.feed.last_modified = remote_feed.last_modified
    link.referrers << link.url
    link.save

    urls = Link.all(:conditions => {:url => {:'$in' => remote_feed.entries.map(&:url)}}).map(&:url)
    remote_feed.entries.map do |entry|
      next if urls.include?(entry.url)
      create(
        :title     => entry.title,
        :url       => entry.url,
        :referrers => [link.url]
      )
      # TODO: Dig links out of content as well.
    end
  rescue => e
    Merb.logger.error("Feed Error (#{url}): #{e.message}")
  end

  def self.discover(url, deep = true)
    feed = new(:url => url)
    feed.validate_only('true_for/url') # TODO: Group.
    raise MongoMapper::DocumentNotValid.new(feed) unless feed.errors.empty?

    link = first(:url => feed.url, :feed => {:'$ne' => nil})
    return link if link

    if deep && primary = Columbus.new(feed.url).primary
      return discover(primary.url.to_s, false)
    end

    feed.save && feed.selfupdate
    feed
  end
end # Link

