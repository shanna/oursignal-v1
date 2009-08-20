require 'schedule/job'

module Oursignal
  module Feed
    class Expire < Schedule::Job
      self.interval = 600 # Ten minutes.

      def call
        links = Link.all(:created_at.lt => (Time.now - 2.day).to_datetime)
        unless links.empty?
          Merb.logger.info("expire\tdeleting expired #{links.size} links")
          links.each(&:destroy)
        end
      end
    end
  end # Feed
end # Oursignal
