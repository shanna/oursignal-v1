require 'oursignal/job'

module Oursignal
  module Score
    class Expire < Job
      self.poll_time = 600 # Ten minutes.

      def poll
        ::Score.all(:created_at.lt => (Time.now - 1.week).to_datetime)
      end

      def work(scores)
        Merb.logger.info("expire\tdeleting expired #{links.size} scores") unless scores.empty?
        scores.each(&:destroy)
      end
    end
  end # Score
end # Oursignal

