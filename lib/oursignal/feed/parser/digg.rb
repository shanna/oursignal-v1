require 'oj'

require 'oursignal/feed/parser'

module Oursignal
  class Feed
    class Parser
      class Digg < Parser
        def initialize
          super Oursignal::Feed.find('http://digg.com')
        end

        def urls
          %w{http://services.digg.com/2.0/story.getTopNews?type=json}
        end

        def parse source
          begin
            data = Oj.load(source, symbol_keys: true) || return
            data[:stories].each do |entry|
              begin
                score     = entry[:diggs].to_i || next
                url       = entry[:url]        || next
                title     = entry[:title]
                entry_url = entry[:permalink]

                Entry.upsert url: entry_url, feed_id: feed.id, link: {url: url, score_digg: score, title: title}
              rescue => error
                warn [error.message, *error.backtrace].join("\n")
              end
            end
          rescue => error
            warn [error.message, *error.backtrace].join("\n")
          end
        end
      end # Reddit
    end # Parser
  end # Feed
end # Oursignal

