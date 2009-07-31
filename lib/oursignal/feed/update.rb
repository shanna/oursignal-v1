require 'oursignal/job'

module Oursignal
  module Feed
    class Update < Job
      self.poll_time = 30

      def poll
        ::Feed.all(:updated_at.lt => (Time.now - 30.minutes).to_datetime)
      end

      def work(links = [])
        links.each(&:selfupdate)
      end
    end # Update
  end # Feed
end # Oursignal

