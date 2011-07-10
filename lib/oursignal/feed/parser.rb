require 'resque'
require 'uri/domain'

# Business.
require 'oursignal/entry'
require 'oursignal/feed'
require 'oursignal/link'

module Oursignal
  class Feed
    class Parser
      attr_reader :feed

      def initialize feed
        @feed = feed
      end

      def parse source
        raise NotImplementedError
      end

      def urls
        raise NotImplementedError
      end

      class << self
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

