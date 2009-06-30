class Score
  include MongoMapper::EmbeddedDocument
  key :source, String # DBRef later?
  key :score,  Integer
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
  key :score,     Integer
  key :feed,      ::Feed, :default => Feed.new
  many :scores

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

    urls = Link.all(:url => {:'$in' => remote_feed.entries.map(&:url)}).map(&:url)
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

  def self.discover(url)
    uri = URI.parse(Addressable::URI.heuristic_parse(url, {:scheme => 'http'}).normalize!)
    raise MongoMapper::DocumentNotValid.new("That's no URI: '#{uri}'") unless uri.is_a?(URI::HTTP)

    uri     = uri.to_s
    primary = Columbus.new(uri).primary
    url     = {:url => primary.nil? ? uri : primary.url.to_s}
    unless first(url)
      feed = create(url)
      feed.selfupdate
      feed
    end
  end
end # Link

