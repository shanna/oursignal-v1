require 'oursignal/job'

module Oursignal
  module Feed
    class Update < Job
      self.poll_time = 30

      def poll
        ::Feed.all(:updated_at.lt => Time.now - 60 * 15)
      end

      def work(links = [])
        links.each(&:selfupdate)
      end
    end # Update
  end # Feed
end # Oursignal

