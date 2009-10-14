require 'math/uniform_distribution'

class Velocity
  module Normalize
    def normalized
      ((velocity_distribution.at(velocity).to_f * (2.to_f / 100)) - 1).round(2)
    end

    def velocity_distribution
      Math::UniformDistribution.new(:velocity) do
        total = ::Link.count
        last  = ::Link.first(:order => [:velocity_average.desc]).velocity_average
        (1 .. 100).to_a.map! do |range|
          offset = (total * (range.to_f / 100)).to_i
          link   = ::Link.first(:order => [:velocity_average.asc], :offset => offset)
          link ? link.velocity_average : last
        end
      end
    end
  end # Normalize
end # Velocity
