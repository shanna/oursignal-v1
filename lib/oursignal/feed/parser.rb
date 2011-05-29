require 'resque'
require 'uri/domain'

# Business.
require 'oursignal/feed'

module Oursignal
  class Feed
    class Parser
      attr_reader :feed

      def initialize feed
        @feed = feed
      end

      def parse io
        raise NotImplementedError
      end

      class << self
        def parse? url
          raise NotImplementedError
        end

        def find feed
          all.find{|parser| parser.parse?(feed.url)}
        end

        def all
          @@all ||= Set.new
        end

        def inherited klass
          self.all << klass
        end
      end
    end # Parser
  end # Feed
end # Oursignal

# TODO: Fugly factory is fugly.
require 'oursignal/feed/parser/digg'
require 'oursignal/feed/parser/delicious'
require 'oursignal/feed/parser/reddit'
require 'oursignal/feed/parser/ycombinator'

