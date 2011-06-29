require 'resque'
require 'yajl'

require 'oursignal/link'

module Oursignal
  module Score
    class Parser
      attr_reader :links

      def initialize links
        @links = links
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
    end # Native
  end # Score
end # Oursignal

# TODO: Fugly factory is fugly.
require 'oursignal/score/native/delicious'
require 'oursignal/score/native/digg'
require 'oursignal/score/native/facebook'
require 'oursignal/score/native/googlebuzz'
require 'oursignal/score/native/reddit'
require 'oursignal/score/native/twitter'
# require 'oursignal/score/native/ycombinator'

