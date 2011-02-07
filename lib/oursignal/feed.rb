require 'resque'
require 'uri/sanitize'

# Schema.
require 'oursignal/scheme/feed'
require 'oursignal/scheme/user_feed'

module Oursignal
  module Feed
    class << self
      def search identifier
        Scheme::Feed.first 'url = ?', identifier
      end

      def discover original_url
        url  = URI.sanitize(original_url).to_s
        feed = search url

        # Pop in placeholder and schedule get.
        unless feed
          feed = Scheme::Feed.create(url: url).first
          rss_update feed
        end

        feed
      end

      def rss_update *feeds
        feeds = Scheme::Feed.all(%q{updated_at < now() - interval '15 minutes'}) if feeds.empty?
        feeds.each{|feed| Resque::Job.create :rss_get, 'Oursignal::Job::RssGet', feed.url}
      end
    end
  end # Feed
end # Oursignal

