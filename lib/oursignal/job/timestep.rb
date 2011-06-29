require 'resque'

require 'oursignal/score/timestep'

module Oursignal
  module Job
    class Timestep
      extend Resque::Plugins::Lock
      @queue = :timestep

      def self.perform
        Oursignal::Score::Timestep.perform
      end
    end # Step
  end # Job
end # Oursignal


