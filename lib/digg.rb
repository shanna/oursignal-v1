require 'addressable/uri'
require 'curb'
require 'nokogiri'
require 'uri'

class Digg
  XSLT       = Nokogiri::XSLT.parse(File.read(File.join(File.dirname(__FILE__), 'digg', 'rss.xslt')))
  USER_AGENT = 'oursignal-digg/2 +oursignal.com'
  HEADERS    = {'User-Agent' => USER_AGENT}

  #--
  # TODO: Switch to SAX?
  def self.read
    xml  = Nokogiri::XML::Document.new
    root = xml.add_child(Nokogiri::XML::Element.new('stories', xml))
    urls = containers.map{|c| uri("/stories/container/#{c}/popular")}
    Curl::Multi.get(urls, {:headers => HEADERS}) do |response|
      Nokogiri::XML.parse(response.body_str).xpath('//story').each do |story|
        story['published'] = Time.at(story['submit_date'].to_i).httpdate
        root.add_child(story)
      end
    end
    XSLT.transform(xml)
  end

  private
    def self.containers
      curl = Curl::Easy.http_get(uri('/containers')){|e| e.headers = HEADERS}
      curl.perform
      Nokogiri::XML.parse(curl.body_str).xpath('//container/@short_name').map{|c| c.text}
    end

    def self.uri(endpoint)
      digg = Addressable::URI.parse("http://services.digg.com")
      digg.path         = endpoint
      digg.query_values = {
        'appkey' => 'http://oursignal.com/',
        'type'   => 'xml'
      }
      digg
    end
end
