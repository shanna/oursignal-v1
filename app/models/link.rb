require 'uri/sanatize'
require 'uri/domain'

class Link
  include DataMapper::Resource
  property :id,                 DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :url,                URI, :length => 255, :nullable => false, :unique_index => true
  property :title,              String, :length => 255
  property :domains,            Json
  property :score,              Float, :default => 0
  property :velocity,           Float, :default => 0
  property :score_at,           DateTime, :index => true
  property :meta_at,            DateTime, :index => true
  property :referred_at,        DateTime, :default => proc{ DateTime.now}
  property :created_at,         DateTime, :index => true
  property :updated_at,         DateTime

  has n, :feed_links, :constraint => :destroy!
  has n, :feeds, :through => :feed_links

  def to_json(options = {})
    {
      :url      => url,
      :title    => title,
      :score    => score,
      :velocity => velocity,
      :domains  => domains
    }.to_json
  end

  def score=(f)
    attribute_set(:score, (f ? f.to_f.round(5) : 0))
  end

  def velocity=(f)
    attribute_set(:velocity, (f ? f.to_f.round(5) : 0))
  end

  #--
  # TODO: Can this be done as a relationship?
  def scores
    Score.all(:url => url)
  end

  def self.update(feed, remote_feed)
    links = {}
    remote_feed.entries.each do |entry|
      links[entry.url] = entry.title
      xml              = Nokogiri::XML.parse("<r>#{entry.summary}</r>") rescue next
      xml.xpath('//a').each do |anchor|
        url   = URI.parse(anchor.attribute('href').text) rescue next
        title = anchor.text.strip
        next unless title =~ /\w+/ && url.is_a?(URI::HTTP)
        next if feed.url.domain == url.domain
        links[url.to_s] = entry.title
      end
    end

    links.map do |url, title|
      url = URI.sanatize(url) rescue next
      next if feed.feed_links.first(:url => url)
      link             = first_or_new({:url => url}, :title => title)
      link.domains     = link.feeds.map(&:domain).push(feed.domain).uniq
      link.referred_at = DateTime.now
      link.save && feed.feed_links.first_or_create({:link => link}, :url => url)
    end
  end
end # Link

