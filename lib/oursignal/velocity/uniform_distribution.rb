require 'math/uniform_distribution'

module Oursignal
  module Velocity
    module UniformDistribution
      VELOCITY_PRECISION = 100

      def velocity_normal(velocity)
        ((velocity_distribution.at(velocity).to_f * (2.to_f / VELOCITY_PRECISION)) - 1).round(2)
      end

      def velocity_distribution
        Math::UniformDistribution.new(:velocity) do
          total = ::Link.count(:score.gt => 0)
          last  = ::Link.first(:order => [:velocity.desc]).velocity
          (1 .. VELOCITY_PRECISION).to_a.map! do |range|
            offset = (total * (range.to_f / VELOCITY_PRECISION)).to_i
            link   = ::Link.first(:order => [:velocity.asc], :offset => offset)
            link ? link.velocity : last
          end
        end
      end
    end # UniformDistribution
  end # Velocity
end # Oursignal
