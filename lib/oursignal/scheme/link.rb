require 'oursignal/scheme'
require 'oursignal/scheme/score'

module Oursignal
  class Scheme
    class Link < Scheme
      store :links
      attribute :id,           Swift::Type::Integer, serial: true, key: true
      attribute :url,          Swift::Type::String
      attribute :title,        Swift::Type::String
      attribute :summary,      Swift::Type::String
      attribute :tags,         Swift::Type::String
      attribute :content_type, Swift::Type::String
      attribute :updated_at,   Swift::Type::DateTime, default: proc{ Time.now }
      attribute :created_at,   Swift::Type::DateTime, default: proc{ Time.now }
      attribute :referred_at,  Swift::Type::DateTime, default: proc{ Time.now }
      Score.sources.each{|source| attribute source, Swift::Type::Float, default: 0 }
    end # Link
  end # Scheme
end # Oursignal
