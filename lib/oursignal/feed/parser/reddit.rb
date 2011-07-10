require 'resque'
require 'yajl'

require 'oursignal/feed/parser'

module Oursignal
  class Feed
    class Parser
      class Reddit < Parser
        def initialize
          super Oursignal::Feed.find('http://reddit.com')
        end

        def urls
          %w{http://www.reddit.com/.json}
        end

        def parse source
          feed = Feed.find('http://reddit.com') || return
          Yajl::Parser.new(symbolize_keys: true).parse(source)[:data][:children].each do |entry|
            begin
              score     = entry[:data][:score].to_i || next
              url       = entry[:data][:url]        || next
              title     = entry[:data][:title]
              entry_url = 'http://www.reddit.com/' + entry[:data][:permalink]

              Entry.upsert url: entry_url, feed_id: feed.id, link: {url: url, score_reddit: score, title: title}
            rescue => error
              warn [error.message, *error.backtrace].join("\n")
            end
          end
        end
      end # Reddit
    end # Parser
  end # Feed
end # Oursignal

