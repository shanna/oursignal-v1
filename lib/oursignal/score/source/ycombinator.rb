require 'oursignal/score/source'
require 'nokogiri'

module Oursignal
  module Score
    class Source
      class Ycombinator < Source
        self.poll_time = 60 * 15

        def http_uri
          @http_uri ||= uri('http://news.ycombinator.com/').freeze
        end

        def work(data = '')
          Nokogiri::HTML.parse(data).css('td.title a').each do |entry|
            points = entry.xpath('../../following-sibling::tr[1]/td/span').text.to_i
            score(entry.attribute('href').text, points) if points > 0
          end
        end
      end # Ycombinator
    end # Source
  end # Score
end # Oursignal
