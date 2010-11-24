require 'oursignal/feed'
require 'oursignal/link'

module Oursignal
  class FeedLink < Swift::Scheme
    store :feed_links
    attribute :feed_id, Swift::Type::Integer, key: true
    attribute :link_id, Swift::Type::Integer, key: true
    attribute :url,     Swift::Type::String

    def feed; Oursignal::Feed.get(feed_id) end
    def link; Oursignal::Link.get(link_id) end
  end
end # Oursignal
