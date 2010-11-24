module Oursignal
  class Feed < Swift::Scheme
    store :feeds
    attribute :id,            Swift::Type::Integer, serial: true, key: true
    attribute :title,         Swift::Type::String
    attribute :site,          Swift::Type::String
    attribute :url,           Swift::Type::String
    attribute :etag,          Swift::Type::String
    attribute :last_modified, Swift::Type::Time
    attribute :total_links,   Swift::Type::Integer, default: 0
    attribute :daily_links,   Swift::Type::Float,   default: 0
    attribute :updated_at,    Swift::Type::Time,    default: proc{ Time.now }
    attribtue :created_at,    Swift::Type::Time,    default: proc{ Time.now }
  end # Feed
end # Oursignal
