require 'schedule/job'

module Oursignal
  module Score
    class Expire < Schedule::Job
      self.interval = 600 # Ten minutes.

      def call
        scores = ::Score.all(:created_at.lt => (Time.now - 1.week).to_datetime)
        unless scores.empty?
          Merb.logger.info("expire\tdeleting expired #{links.size} scores")
          scores.each(&:destroy)
        end
      end
    end
  end # Score
end # Oursignal

