require 'oursignal/job'

module Oursignal
  module Velocity
    class Update < Job
      include ::Velocity::Normalize

      def call
        velocity_distribution.reload

        # Handy for debugging.
        # ud = []
        # velocity_distribution.cache.each_with_index{|v, i| ud << [i, '%.5f' % v]}
        # Merb.logger.info("Velocity Distribution: \n\r#{ud.inspect}")

        # XXX: While I'm messing, recalculate all velocities.
        Link.all.each do |link|
          link.velocity = normalized(link.velocity_average)
          link.save
        end
      end
    end
  end
end
