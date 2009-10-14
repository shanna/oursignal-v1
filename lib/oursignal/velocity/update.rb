require 'oursignal/job'

module Oursignal
  module Velocity
    class Update < Job
      include ::Velocity::Normalize

      def call
        velocity_distribution.reload
      end
    end
  end
end
