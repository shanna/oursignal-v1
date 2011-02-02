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
          Resque::Job.create :rss_get, 'Ev::Job::RssGet', url # Avoid loading job code just to queue a job.
        end

        feed
      end
    end
  end # Feed
end # Oursignal

