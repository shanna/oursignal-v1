require 'uri/sanatize'
require 'uri/domain'

class Link
  include DataMapper::Resource
  property :id,                 DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :url,                URI, :length => 255, :nullable => false, :unique_index => true
  property :title,              String, :length => 255
  property :domains,            Json
  property :score,              Float, :default => 0
  property :velocity,           Float, :default => 0, :index => true
  property :score_at,           DateTime, :index => true
  property :meta_at,            DateTime, :index => true
  property :referred_at,        DateTime
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

  def domain
    url.domain
  end

  #--
  # TODO: Can this be done as a relationship?
  def scores
    Score.all(:url => url)
  end

  def self.update(feed, remote_feed)
    remote_feed.entries.each do |entry|
      urls = [entry.url]
      xml  = Nokogiri::XML.parse("<r>#{entry.summary}</r>") rescue next
      xml.xpath('//a').each do |anchor|
        url   = URI.parse(anchor.attribute('href').text) rescue next
        title = anchor.text.strip
        next unless title =~ /\w+/ && url.is_a?(URI::HTTP)
        next if feed.domain == url.domain
        urls << url.to_s
      end

      urls.each do |url|
        url = URI.sanatize(url) rescue next
        next if feed.feed_links.first(:url => url)
        title        = entry.title.strip.to_utf8 || next
        link         = first_or_new({:url => url}, :title => title)
        link.domains = link.feeds.map(&:domain).push(feed.domain).uniq

        if referred_at = (entry.published.to_datetime rescue nil)
          link.referred_at = referred_at if link.referred_at.blank? || link.referred_at < referred_at
        else
          link.referred_at = DateTime.now if link.referred_at.blank?
        end

        link.save && feed.feed_links.first_or_create(
          {:link => link},
          :url      => url,
          :external => (feed.domain != link.domain)
        )
      end
    end
  end
end # Link

