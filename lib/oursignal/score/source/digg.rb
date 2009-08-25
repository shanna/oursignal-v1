require 'oursignal/score/source'
require 'nokogiri'

module Oursignal
  module Score
    class Source
      class Digg < Source
        def http_uri
          @http_uri ||= uri('http://services.digg.com/stories/popular',
            'appkey' => 'http://oursignal.com/',
            'type'   => 'xml'
          ).freeze
        end

        def work(data = '')
          # TODO: ./@link is Real URL.
          Nokogiri::XML.parse(data).xpath('//story').each do |story|
            score(story.at('./@href').text, story.at('./@diggs').text.to_i)
          end
        end
      end # Digg
    end # Source
  end # Score
end # Oursignal
