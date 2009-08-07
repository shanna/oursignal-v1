require 'uri/sanatize'
require 'uri/domain'

class Link
  include DataMapper::Resource
  property :id,          DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :url,         URI, :length => 255, :nullable => false, :unique_index => true
  property :title,       String, :length => 255
  property :score,       Float
  property :score_at,    DateTime
  property :velocity,    Float
  property :referred_at, DateTime
  property :created_at,  DateTime
  property :updated_at,  DateTime

  has n, :feeds, :through => Resource, :constraint => :destroy!

  def to_json(options = {})
    {:url => url, :title => title, :score => score, :velocity => velocity}.to_json
  end

  def score=(f)
    attribute_set(:score, (f ? f.round(5) : 0))
  end

  def velocity=(f)
    attribute_set(:velocity, (f ? f.round(5) : 0))
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
        title, url = anchor.text.strip, URI.parse(anchor.attribute('href').text)
        next unless title =~ /\w+/ && url.is_a?(URI::HTTP)
        next if feed.url.domain == url.domain
        links[url.to_s] = entry.title
      end
    end

    # TODO: Use curl-multi to speed up the URI sanatization.
    # URI.sanatize(links.keys) do |url|
    #   url.last_effective_url
    #   links[url.to_s] # title
    # end
    links.map do |url, title|
      url              = URI.sanatize(url) rescue next
      link             = first_or_new({:url => url}, :title => title)
      link.referred_at = DateTime.now
      link.save && feed.feed_links.first_or_create(:link => link)
    end
  end
end # Link

