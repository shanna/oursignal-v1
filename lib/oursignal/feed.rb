# Schema.
require 'oursignal/scheme/feed'

module Oursignal
  class Feed < Scheme::Feed

    def self.read *feeds
      feeds = Scheme::Feed.execute(%q{
        select * from feeds
        where updated_at < now() - interval '10 minutes'
      }) if feeds.empty?
      feeds.each{|feed| Resque::Job.create :feed_get, 'Oursignal::Job::FeedGet', feed.url}
    end
  end # Feed
end # Oursignal

