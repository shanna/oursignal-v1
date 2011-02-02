require 'oursignal/scheme/feed'
require 'oursignal/scheme/link'

module Oursignal
  class Scheme
    class FeedLink < Scheme
      store :feed_links
      attribute :feed_id, Swift::Type::Integer, key: true
      attribute :link_id, Swift::Type::Integer, key: true
      attribute :url,     Swift::Type::String

      def feed; Oursignal::Scheme::Feed.get(feed_id) end
      def link; Oursignal::Scheme::Link.get(link_id) end
    end # FeedLink
  end # Scheme
end # Oursignal
