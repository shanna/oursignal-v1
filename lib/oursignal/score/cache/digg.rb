require 'oursignal/score/cache'
require 'nokogiri'

module Oursignal
  module Score
    class Cache
      class Digg < Cache
        self.poll_time = 60 * 15

        def http_uri
          @http_uri ||= uri('http://services.digg.com/stories/popular',
            'appkey' => 'http://oursignal.com/',
            'type'   => 'xml'
          ).freeze
        end

        def work(data = '')
          xml = Nokogiri::XML.parse(data)
          xml.xpath('//story').each do |story|
            score(story.at('./@link').text, story.at('./@diggs').text)
          end
        end
      end # Digg
    end # Cache
  end # Score
end # Oursignal
