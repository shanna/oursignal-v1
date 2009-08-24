require 'schedule/job'

module Oursignal
  module Feed
    class Update < Schedule::Job
      self.interval = 30

      def call(*args)
        feeds = ::Feed.all(:updated_at.lt => (Time.now - 15.minutes).to_datetime)
        unless feeds.empty?
          Merb.logger.info("updating #{feeds.size} feeds")
          feeds.each(&:selfupdate)
        end
      end
    end # Update
  end # Feed
end # Oursignal

