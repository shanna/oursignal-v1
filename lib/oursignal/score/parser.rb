require 'cgi'
require 'yajl'

require 'oursignal/link'
require 'oursignal/score'

module Oursignal
  class Score
    class Parser
      attr_reader :links

      def initialize links
        @links = links
      end

      def parse url, source
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
require 'oursignal/score/parser/digg'
require 'oursignal/score/parser/facebook'
require 'oursignal/score/parser/google'
require 'oursignal/score/parser/reddit'
require 'oursignal/score/parser/twitter'
# require 'oursignal/score/native/ycombinator'

