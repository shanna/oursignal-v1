require 'oursignal/scheme'
require 'oursignal/scheme/feed'
require 'oursignal/scheme/link'

module Oursignal
  class Scheme
    class Entry < Scheme
      store :entries
      attribute :feed_id, Swift::Type::Integer, key: true
      attribute :link_id, Swift::Type::Integer, key: true
      attribute :url,     Swift::Type::String

      def feed; Scheme::Feed.get(id: feed_id) end
      def link; Scheme::Link.get(id: link_id) end
    end # Entry
  end # Scheme
end # Oursignal
