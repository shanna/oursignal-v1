require 'oursignal/scheme'

module Oursignal
  class Scheme
    class Link < Scheme
      store :links
      attribute :id,                Swift::Type::Integer, serial: true, key: true
      attribute :url,               Swift::Type::String
      attribute :title,             Swift::Type::String
      attribute :content_type,      Swift::Type::String
      attribute :score_digg,        Swift::Type::Float,    default: 0
      attribute :score_facebook,    Swift::Type::Float,    default: 0
      attribute :score_frequency,   Swift::Type::Float,    default: 0
      attribute :score_freshness,   Swift::Type::Float,    default: 0
      attribute :score_googlebuzz,  Swift::Type::Float,    default: 0
      attribute :score_reddit,      Swift::Type::Float,    default: 0
      attribute :score_twitter,     Swift::Type::Float,    default: 0
      attribute :score_ycombinator, Swift::Type::Float,    default: 0
      attribute :updated_at,        Swift::Type::DateTime, default: proc{ Time.now }
      attribute :created_at,        Swift::Type::DateTime, default: proc{ Time.now }
      attribute :referred_at,       Swift::Type::DateTime, default: proc{ Time.now }
    end # Link
  end # Scheme
end # Oursignal
