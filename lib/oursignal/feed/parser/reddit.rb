require 'resque'
require 'yajl'

require 'oursignal/feed/parser'

module Oursignal
  class Feed
    class Parser
      class Reddit < Parser
        def self.parse? url
          URI.domain(url) == 'reddit.com'
        end

        def parse source
          Yajl::Parser.new(symbolize_keys: true).parse(source)[:data][:children].each do |entry|
            begin
              score     = entry[:data][:score].to_i || next
              url       = entry[:data][:url]        || next
              title     = entry[:data][:title]
              entry_url = 'http://www.reddit.com/' + entry[:data][:permalink]

              Resque::Job.create :entry, 'Oursignal::Job::Entry', feed.id, entry_url, url, 'score_reddit', score, title
            rescue => error
              warn error.message
            end
          end
        end
      end # Reddit
    end # Parser
  end # Feed
end # Oursignal

