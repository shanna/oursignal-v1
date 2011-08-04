require 'resque'
require 'resque/plugins/lock'

require 'oursignal/score/reader'

module Oursignal
  module Job
    class Score
      extend Resque::Plugins::Lock
      @queue = :score

      def self.perform
        Oursignal::Score::Reader.perform
      end
    end # Score
  end # Job
end # Oursignal

