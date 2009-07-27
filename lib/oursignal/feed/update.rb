require 'oursignal/job'

module Oursignal
  module Feed
    class Update < Job
      self.poll_time = 30

      def poll
        # TODO: Why is + busted here.
        links =  Link.all(:conditions => {:'feed.url' => {:'$ne' => nil}, :'feed.updated_at' => nil})
        links << Link.all(:conditions => {:'feed.url' => {:'$ne' => nil}, :'feed.updated_at' => {:'$lt' => Time.now - 60 * 15}})
        links.flatten.uniq
      end

      def work(links = [])
        links.each(&:selfupdate)
      end
    end # Update
  end # Feed
end # Oursignal

