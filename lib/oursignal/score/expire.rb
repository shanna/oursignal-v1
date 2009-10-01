require 'oursignal/job'

module Oursignal
  module Score
    class Expire < Job
      def call
        scores = ::Score.all(:created_at.lt => (Time.now - 1.week).to_datetime)
        unless scores.empty?
          Merb.logger.info("expire\tdeleting expired #{scores.size} scores")
          scores.each(&:destroy)
        end
      end
    end
  end # Score
end # Oursignal

