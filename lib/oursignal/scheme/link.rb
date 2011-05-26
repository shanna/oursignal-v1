require 'oursignal/scheme'

module Oursignal
  class Scheme
    class Link < Scheme
      store :links
      attribute :id,                       Swift::Type::Integer, serial: true, key: true
      attribute :url,                      Swift::Type::String
      attribute :title,                    Swift::Type::String
      attribute :score_delicious,          Swift::Type::Float,   default: 0
      attribute :score_digg,               Swift::Type::Float,   default: 0
      attribute :score_frequency,          Swift::Type::Float,   default: 0
      attribute :score_freshness,          Swift::Type::Float,   default: 0
      attribute :score_reddit,             Swift::Type::Float,   default: 0
      attribute :score_twitter,            Swift::Type::Float,   default: 0
      attribute :score_ycombinator,        Swift::Type::Float,   default: 0
      attribute :updated_at,               Swift::Type::Time,    default: proc{ Time.now }
      attribute :created_at,               Swift::Type::Time,    default: proc{ Time.now }
    end # Link
  end # Scheme
end # Oursignal
