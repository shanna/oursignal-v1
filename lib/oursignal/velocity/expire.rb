require 'oursignal/job'

module Oursignal
  module Velocity
    class Expire < Job
      def call
        velocities = ::Velocity.all(:created_at.lt => (Time.now - 1.week).to_datetime)
        unless velocities.empty?
          Merb.logger.info("expire\tdeleting expired #{velocities.size} velocities")
          velocities.each(&:destroy)
        end
      end
    end
  end
end
