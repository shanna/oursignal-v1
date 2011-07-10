# Schema.
require 'oursignal/scheme/entry'

# Business.
require 'oursignal/feed'
require 'oursignal/link'

module Oursignal
  class Entry < Scheme::Entry
    def self.upsert attributes
      transaction do
        feed_id = attributes.fetch(:feed_id, Feed.upsert(attributes[:feed]).id)
        link_id = attributes.fetch(:link_id, Link.upsert(attributes[:link]).id)

        get(feed_id: feed_id, link_id: link_id) ||
          create(feed_id: feed_id, link_id: link_id, url: attributes.fetch(:url))
      end
    end
  end # Entry
end # Oursignal

