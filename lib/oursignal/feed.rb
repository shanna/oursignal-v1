require 'resque'
require 'uri/sanitize'

# Schema.
require 'oursignal/scheme/feed'
require 'oursignal/scheme/user_feed'

module Oursignal
  module Feed
    class << self
      def search identifier
        Scheme::Feed.first 'url = ?', URI.sanitize(identifier.to_s).to_s
      end

      def discover original_url
        url  = URI.sanitize(original_url.to_s).to_s
        feed = search url

        # Pop in placeholder and schedule get.
        unless feed
          feed = Scheme::Feed.create(url: url).first
          http_update feed
        end

        feed
      end

      def http_update *feeds
        feeds = Scheme::Feed.all(%q{updated_at < now() - interval '15 minutes'}) if feeds.empty?
        feeds.each{|feed| Resque::Job.create :feed_get, 'Oursignal::Job::FeedGet', feed.url}
      end
    end
  end # Feed
end # Oursignal

