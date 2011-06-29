require 'nokogiri'
require 'resque'

require 'oursignal/feed/parser'

module Oursignal
  class Feed
    class Parser
      class Ycombinator < Parser
        def initialize
          super Oursignal::Feed.find('http://news.ycombinator.com')
        end

        def urls
          %w{http://news.ycombinator.com}
        end

        def parse source
          Nokogiri::HTML.parse(source).css('td.title a').each do |entry|
            begin
              score     = entry.xpath('../../following-sibling::tr[1]/td/span').text.to_i || next
              entry_a   = entry.xpath('../../following-sibling::tr[1]/td/a[2]') || next
              entry_url = 'http://news.ycombinator.com/' + entry_a.attribute('href').text
              title     = entry.text
              url       = entry.attribute('href').text
              url       = 'http://news.ycombinator.com/' + url unless url =~ %r{://}

              Resque::Job.create :entry, 'Oursignal::Job::Entry', feed.id, entry_url, url, 'score_ycombinator', score, title
            rescue => error
              warn [error.message, *error.backtrace].join("\n")
            end
          end
        end
      end # Ycombinator
    end # Parser
  end # Feed
end # Oursignal

