require 'oursignal/job'

module Oursignal
  module Feed
    class Update < Job
      self.poll_time = 15

      def poll
        Link.all(:conditions => {:'feed.updated_at' => {:'$lt' => Time.now - 60 * 30}})
      end

      def work(links = [])
        links.each(&:selfupdate)
      end
    end # Update
  end # Feed
end # Oursignal

