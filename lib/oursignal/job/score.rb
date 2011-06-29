require 'resque'

require 'oursignal/score/reader'

module Oursignal
  module Job
    class Score
      extend Resque::Plugins::Lock
      @queue = :score

      def self.perform source_klass, link_id
        Oursignal::Score::Reader.perform
      end
    end # Score
  end # Job
end # Oursignal

