require 'oursignal/scheme'
require 'oursignal/scheme/feed'

module Oursignal
  class Scheme
    class Entry < Scheme
      store :entries
      attribute :id,         Swift::Type::Integer, serial: true, key: true
      attribute :feed_id,    Swift::Type::Integer
      attribute :url,        Swift::Type::String
      attribute :updated_at, Swift::Type::Time,    default: proc{ Time.now }
      attribute :created_at, Swift::Type::Time,    default: proc{ Time.now }

      def feed; Oursignal::Scheme::Feed.get(feed_id) end
    end # Entry
  end # Scheme
end # Oursignal
