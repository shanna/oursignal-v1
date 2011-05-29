require 'resque'
require 'yajl'

require 'oursignal/feed/parser'

module Oursignal
  class Feed
    class Parser
      class Digg < Parser
        def self.parse? url
          URI.domain(url) == 'digg.com'
        end

        def parse source
          Yajl::Parser.new(symbolize_keys: true).parse(source)[:stories].each do |entry|
            begin
              score     = entry[:diggs].to_i || next
              url       = entry[:url]        || next
              title     = entry[:title]
              entry_url = entry[:permalink]

              Resque::Job.create :entry, 'Oursignal::Job::Entry', feed.id, entry_url, url, 'score_digg', score, title
            rescue => error
              warn error.message
            end
          end
        end
      end # Reddit
    end # Parser
  end # Feed
end # Oursignal

