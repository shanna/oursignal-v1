require 'resque'
require 'uri/sanitize'

# Business.
require 'oursignal/feed'

module Oursignal
  class Feed
    def self.discover original_url
      url  = URI.sanitize(original_url)
      feed = Oursignal::Feed.find(url)

      unless feed
        feed = Scheme::Feed.create(url: url)
        Feed.read feed
      end

      feed
    end
  end # Feed
end # Oursignal

