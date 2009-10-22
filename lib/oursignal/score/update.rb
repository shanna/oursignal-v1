require 'oursignal/job'

module Oursignal
  module Score
    class Update < Job

      def call
        # TODO: I can build an 'OR' with DM::Query even if the class finders can't do it yet.
        links =  Link.all(:score_at.lt => (Time.now - 5.minutes).to_datetime)
        links += Link.all(:score_at => nil)
        unless links.empty?
          links.each do |link|
            prev_link, next_link = *link.selfupdate
            Merb.logger.debug(
              %Q{%s, %s
                \r  age: %.5f
                \r  old:
                \r    score_average:    %.5f
                \r    score_bonus:      %.5f
                \r    score:            %.5f
                \r    velocity_average: %.5f
                \r    velocity:         %.5f
                \r  new:
                \r    score_average:    %.5f
                \r    score_bonus:      %.5f
                \r    score:            %.5f
                \r    velocity_average: %.5f
                \r    velocity:         %.5f
              } % [
                next_link.id,
                prev_link.url,
                next_link.age,
                prev_link.score_average,
                prev_link.score_bonus,
                prev_link.score,
                prev_link.velocity_average,
                prev_link.velocity,
                next_link.score_average,
                next_link.score_bonus,
                next_link.score,
                next_link.velocity_average,
                next_link.velocity
              ]
            )
          end
        end
      end

    end # Update
  end # Score
end # Oursignal

