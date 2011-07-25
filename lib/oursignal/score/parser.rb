require 'cgi'
require 'resque'
require 'yajl'

require 'oursignal/link'

module Oursignal
  class Score
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
require 'oursignal/score/parser/delicious'
require 'oursignal/score/parser/digg'
require 'oursignal/score/parser/facebook'
require 'oursignal/score/parser/googlebuzz'
require 'oursignal/score/parser/reddit'
require 'oursignal/score/parser/twitter'
# require 'oursignal/score/native/ycombinator'

