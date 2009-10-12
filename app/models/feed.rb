require 'uri/sanatize'
require 'uri/domain'
require 'dm/types/digest'

class Feed
  class Error < StandardError; end

  include DataMapper::Resource
  property :id,             DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :title,          String, :length => 255
  property :site,           URI, :length => 255
  property :url,            URI, :length => 255, :nullable => false, :unique_index => true
  property :etag,           String, :length => 255
  property :last_modified,  DateTime
  property :total_links,    Integer, :default => 0
  property :daily_links,    Float, :default => 0
  property :created_at,     DateTime, :index => true
  property :updated_at,     DateTime, :index => true

  has n, :user_feeds, :constraint => :destroy!
  has n, :feed_links, :constraint => :destroy!
  has n, :users, :through => :user_feeds
  has n, :links, :through => :feed_links

  validates_with_method :url, :method => :validate_url, :when => [:default, :discover]
  validates_with_method :url, :method => :validate_url_is_rss, :when => [:discover]

  # Common form of 'domain name', name + public suffix.
  def domain
    # I was trying to avoid this shit so hard. Fuck you digg.
    if site.domain =~ /^(?:oursignal.com|.*\.local)$/ && site.path =~ %r{rss/digg.rss}
      return 'digg.com'
    end
    site.domain
  end

  # TODO: Move all the update code to a mixin?
  def selfupdate
    success, feed = *fetch_and_parse
    if success && feed != 304
      # The order of stuff is very important here.
      self.title         = feed.title
      self.site          = URI.sanatize(feed.url) if site.blank? && !feed.url.blank?
      self.etag          = feed.etag
      self.last_modified = feed.last_modified.to_datetime unless feed.last_modified.blank?
      self.updated_at    = DateTime.now

      if !new? || save
        Link.update(self, feed)
        self.total_links = FeedLink.count(:feed => self)
        age              = ((updated_at.to_time - created_at.to_time).to_f / 1.day).to_i
        self.daily_links = age >= 1 ? (total_links.to_f / age).round(2) : total_links
      end
    end
  rescue
    DataMapper.logger.error("feed\terror\n#{$!.message}\n#{$!.backtrace}")
  ensure
    self.updated_at = DateTime.now
    return save
  end

  def self.discover(url, options = {})
    url  = URI.sanatize(url.to_s)

    begin
      meta = URI::Meta.get(URI.parse(url), :timeout => 5)
      url  = (meta.feed || meta.last_effective_uri) if meta
    rescue => e
    rescue NotImplementedError => e
    end

    feed = first_or_new(:url => url.to_s)
    return feed unless feed.new? && feed.valid?(:discover)

    feed.selfupdate
    feed
  end

  protected
    def validate_url
      sanatized = URI.sanatize(url.to_s)
      URI.parse(sanatized.to_s).is_a?(URI::HTTP) || [false, 'Must be http(s) scheme.']
    rescue
      [false, error.message]
    end

    def validate_url_is_rss
      return true if validate_url.is_a?(Array) # Skip if we've already established the URL is junk.
      success, error = *fetch_and_parse
      success || [success, error]
    rescue
      [false, $!.message]
    end

    USER_AGENT = 'oursignal-rss/2 +oursignal.com'
    def fetch_and_parse
      options                     = {:user_agent => USER_AGENT, :timeout => 5}
      options[:if_modified_since] = last_modified.to_time unless last_modified.blank?
      options[:if_none_match]     = etag unless etag.blank?

      case feed = Feedzirra::Feed.fetch_and_parse(url.to_s, options)
        when Feedzirra::Parser::RSS, Feedzirra::Parser::Atom, 304 then [true, feed]
        when nil                                                  then [false, 'Not an RSS feed']
        when 0                                                    then [false, 'Timed out']
        when Fixnum                                               then [false, "Returned #{feed} status"]
        else [false, 'Not an RSS feed?']
      end
    rescue
      [false, "Read error, no response from site."]
    end
end

