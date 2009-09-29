require 'oursignal/job'
require 'oursignal/velocity/uniform_distribution'

module Oursignal
  module Velocity
    class Update < Job
      include Oursignal::Velocity::UniformDistribution

      def call
        velocity_distribution.reload
      end
    end
  end
end
