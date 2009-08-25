require 'oursignal/score/source'
require 'nokogiri'

module Oursignal
  module Score
    class Source
      class Delicious < Source
        def http_uri
          @http_uri ||= uri('http://delicious.com/popular/').freeze
        end

        def work(data = '')
          Nokogiri::HTML.parse(data).css('.data').each do |entry|
            score(
              entry.css('.taggedlink').first.attribute('href').to_s,
              entry.css('.delNavCount').text.to_i
            )
          end
        end
      end # Delicious
    end # Source
  end # Score
end # Oursignal
