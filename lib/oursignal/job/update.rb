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
        Job.info 'Perform Oursignal::Feed::Reader...'
        Oursignal::Feed::Reader.perform
        Job.info 'Perform Oursignal::Score::Reader...'
        Oursignal::Score::Reader.perform
        Job.info 'Perform Oursignal::Score::Timestep...'
        Oursignal::Score::Timestep.perform
      end
    end # Update
  end # Job
end # Oursignal

