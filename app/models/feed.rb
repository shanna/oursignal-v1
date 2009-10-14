require 'dm/types/digest'
require 'feed/discover'
require 'feed/update'
require 'uri/domain'
require 'uri/sanatize'

class Feed
  include Feed::Discover
  include Feed::Update

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

  validates_with_method :url, :method => :validate_url,        :when => [:default, :discover]
  validates_with_method :url, :method => :validate_url_is_rss, :when => [:discover]

  after :create, :selfupdate

  # Common form of 'domain name', name + public suffix.
  def domain
    # I was trying to avoid this shit so hard. Fuck you digg.
    return 'digg.com' if site.domain =~ /^(?:oursignal.com|.*\.local)$/ && site.path =~ %r{rss/digg.rss}
    site.domain
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
end

