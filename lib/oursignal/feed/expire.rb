require 'oursignal/job'

module Oursignal
  module Feed
    class Expire < Job
      self.poll_time = 600 # Ten minutes.

      def poll
        Link.all(:created_at.lt => (Time.now - 1.day).to_datetime)
      end

      def work(links)
        Merb.logger.info("expire\tdeleting expired #{links.size} links") unless links.empty?
        links.each(&:destroy)
      end
    end
  end # Feed
end # Oursignal
