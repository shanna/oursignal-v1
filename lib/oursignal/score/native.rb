require 'resque'
require 'yajl'

require 'oursignal/link'

module Oursignal
  module Score
    class Native
      attr_reader :link

      def initialize link
        @link = link
      end

      def parse source
        raise NotImplementedError
      end

      def url
        raise NotImplementedError
      end

      class << self
        def find klass
          all.find{|s| s.to_s.downcase == klass.to_s.downcase}
        end

        def all
          @@all ||= Set.new
        end

        def inherited klass
          self.all << klass
        end

        def read
          Resque::Job.create :score_native, 'Oursignal::ScoreNative'
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

