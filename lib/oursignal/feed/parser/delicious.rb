require 'nokogiri'
require 'resque'

require 'oursignal/feed/parser'

module Oursignal
  class Feed
    class Parser
      class Delicious < Parser
        def initialize
          super Oursignal::Feed.find('http://delicious.com')
        end

        def urls
          %w{http://delicious.com/popular}
        end

        def parse source
          Nokogiri::HTML.parse(source).css('.data').each do |entry|
            begin
              score     = entry.at_css('.delNavCount').text.strip.to_i || next
              link      = entry.at_css('.taggedlink')                  || next
              entry_url = 'http://delicious.com' + entry.at_css('.delNav').attribute('href')
              title     = link.text.strip
              url       = link.attribute('href')

              Resque::Job.create :entry, 'Oursignal::Job::Entry', feed.id, entry_url, url, 'score_delicious', score, title
            rescue => error
              warn [error.message, *error.backtrace].join("\n")
            end
          end
        end
      end # Delicious
    end # Parser
  end # Feed
end # Oursignal

