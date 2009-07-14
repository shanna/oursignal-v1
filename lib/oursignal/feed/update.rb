require 'oursignal/job'

module Oursignal
  module Feed
    class Update < Job
      self.poll_time = 15

      def poll
        Link.all(:conditions => {
          :updated_at => {:'$lt' => Time.now - 60 * 30},
          :feed       => {:'$ne' => {}}
        })
      end

      def work(links = [])
        links.each(&:selfupdate)
      end
    end # Update
  end # Feed
end # Oursignal

