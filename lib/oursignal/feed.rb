# Schema.
require 'oursignal/scheme/feed'
require 'oursignal/scheme/user_feed'

module Oursignal
  module Feed
    class << self
      def search identifier
        Scheme::Feed.first 'url = ?', URI.sanitize(identifier)
      end

      def read *feeds
        feeds = Scheme::Feed.all(%q{updated_at < now() - interval '15 minutes'}) if feeds.empty?
        feeds.each{|feed| Resque::Job.create :feed_get, 'Oursignal::Job::FeedGet', feed.url}
      end
    end
  end # Feed
end # Oursignal

