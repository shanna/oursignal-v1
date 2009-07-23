require 'oursignal/job'

module Oursignal
  module Feed
    class Expire < Job
      self.poll_time = 600 # Ten minutes.

      def poll
        links = Link.all(:conditions => {:created_at => {:'$lt' => Time.now - 86_400}})
        Merb.logger.info("expire\tdeleting #{links.size} links") unless links.empty?
        links
      end

      def work(links)
        links.each(&:destroy)
      end
    end
  end # Feed
end # Oursignal
