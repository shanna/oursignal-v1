require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Job
    class ScoreNative
      extend Resque::Plugins::Lock
      @queue = :score_native

      def self.perform source_klass, link_id
        Oursignal::Score::Native.read
      end
    end # ScoreNative
  end # Job
end # Oursignal

