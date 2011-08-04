require 'resque'
require 'resque/plugins/lock'

require 'oursignal/feed/reader'
require 'oursignal/score/reader'
require 'oursignal/score/timestep'

module Oursignal
  module Job
    class Update
      extend Resque::Plugins::Lock
      @queue = :update

      def self.perform
        Oursignal::Feed::Reader.perform
        Oursignal::Score::Reader.perform
        Oursignal::Score::Timestep.perform
      end
    end # Update
  end # Job
end # Oursignal

