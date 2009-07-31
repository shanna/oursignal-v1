require 'uri/sanatize'

class Link
  include DataMapper::Resource
  property :id,         DataMapper::Types::Digest::SHA1.new(:url), :key => true, :nullable => false
  property :url,        URI, :length => 255, :nullable => false
  property :title,      String, :length => 255
  property :score,      Float, :precision => 10, :scale => 9
  property :score_at,   DateTime
  property :velocity,   Float, :precision => 10, :scale => 9
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :feeds, :through => Resource

  def to_json(options = {})
    {:url => url, :title => title, :score => score, :velocity => velocity}.to_json
  end

  def self.update(feed, remote_feed)
    links = {}
    remote_feed.entries.each do |entry|
      links[entry.url] = entry.title
      xml              = Nokogiri::XML.parse("<r>#{entry.summary}</r>") rescue next
      xml.xpath('//a').each do |anchor|
        title = anchor.text.strip
        next unless title =~ /\w+/
        links[anchor.attribute('href').text] = title
      end
    end

    def score=(f)
      set_attribute(:score, f.round(9))
    end

    def velocity=(f)
      set_attribute(:velocity, f.round(9))
    end

    # TODO: Use curl-multi to speed up the URI sanatization.
    # URI.sanatize(links.keys) do |url|
    #   url.last_effective_url
    #   links[url.to_s] # title
    # end
    links.each do |url, title|
      url = URI.sanatize(url) rescue next
      feed.links << first_or_create(:url => url, :title => title)
    end
    feed.save
  end
end # Link

