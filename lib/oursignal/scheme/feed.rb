require 'oursignal/scheme'

module Oursignal
  class Scheme
    class Feed < Scheme
      store :feeds
      attribute :id,            Swift::Type::Integer,  serial: true, key: true
      attribute :title,         Swift::Type::String
      attribute :site,          Swift::Type::String
      attribute :url,           Swift::Type::String
      attribute :etag,          Swift::Type::String
      attribute :last_modified, Swift::Type::DateTime
      attribute :total_links,   Swift::Type::Integer,  default: 0
      attribute :daily_links,   Swift::Type::Float,    default: 0
      attribute :updated_at,    Swift::Type::DateTime, default: proc{ Time.now }
      attribute :created_at,    Swift::Type::DateTime, default: proc{ Time.now }
    end # Feed
  end # Scheme
end # Oursignal
