require 'math/uniform_distribution'

class Velocity
  module Normalize
    def normalized(v = nil)
      v ||= velocity
      ((velocity_distribution.at(v).to_f * (2.to_f / 100)) - 1).round(2)
    end

    def velocity_distribution
      Math::UniformDistribution.new(:velocity) do
        # Snapshot link velocities.
        date = DateTime.now
        ::Link.repository.adapter.query(%q{select id, velocity_average from links}).each do |v|
          ::Velocity.create(:link_id => v.id, :velocity => v.velocity_average, :created_at => date)
        end

        # Build buckets from the snapshots.
        total = ::Velocity.count
        last  = ::Velocity.first(:order => [:velocity.desc]).velocity
        (1 .. 100).to_a.map! do |range|
          offset = (total * (range.to_f / 100)).to_i
          link   = ::Velocity.first(:order => [:velocity.asc], :offset => offset)
          link ? link.velocity : last
        end
      end
    end
  end # Normalize
end # Velocity
