require 'oursignal/scheme'
require 'oursignal/scheme/feed'
require 'oursignal/scheme/link'

module Oursignal
  class Scheme
    class FeedLink < Scheme
      store :feed_links
      attribute :feed_id, Swift::Type::Integer, key: true
      attribute :link_id, Swift::Type::Integer, key: true
      attribute :url,     Swift::Type::String

      def feed; Scheme::Entry.get(id: entry_id) end
      def link; Scheme::Link.get(id: link_id)   end
    end # EntryLink
  end # Scheme
end # Oursignal
