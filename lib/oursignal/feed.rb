require 'resque'

# Schema.
require 'oursignal/scheme/feed'

module Oursignal
  class Feed < Scheme::Feed
    class << self
      def find id
        execute(%q{select * from feeds where id = ? or url = ?}, id.to_s.to_i, id).first
      end

      def read *feeds
        feeds = execute(%q{
          select * from feeds
          where updated_at < now() - interval '10 minutes'
        }) if feeds.empty?
        feeds.each{|feed| Resque::Job.create :feed_get, 'Oursignal::Job::FeedGet', feed.id}
      end
    end
  end # Feed
end # Oursignal

