# Schema.
require 'oursignal/scheme/entry'

# Business.
require 'oursignal/feed'
require 'oursignal/link'

module Oursignal
  class Entry < Scheme::Entry
    def self.upsert attributes
      Oursignal.db.transaction do
        feed_id = attributes[:feed_id] || Feed.upsert(attributes.fetch(:feed)).id
        link_id = attributes[:link_id] || Link.upsert(attributes.fetch(:link)).id

        get(feed_id: feed_id, link_id: link_id) ||
          create(feed_id: feed_id, link_id: link_id, url: attributes.fetch(:url))
      end
    end
  end # Entry
end # Oursignal

