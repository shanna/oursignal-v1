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

        #--
        # TODO: Ycombinators HTML really is fucking shit so this isn't as robust as it could be.
        def parse source
          Nokogiri::HTML.parse(source).css('td.title a').each do |entry|
            begin
              score     = entry.xpath('../../following-sibling::tr[1]/td/span').text.to_i || next
              entry_a   = entry.xpath('../../following-sibling::tr[1]/td/a[2]') || next
              next if entry_a.empty?
              entry_url = 'http://news.ycombinator.com/' + entry_a.attribute('href').text
              title     = entry.text
              url       = entry.attribute('href').text
              url       = 'http://news.ycombinator.com/' + url unless url =~ %r{://}

              Entry.upsert url: entry_url, feed_id: feed.id, link: {url: url, score_ycombinator: score, title: title}
            rescue => error
              warn [error.message, *error.backtrace].join("\n")
            end
          end
        end
      end # Ycombinator
    end # Parser
  end # Feed
end # Oursignal

