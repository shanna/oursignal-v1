require 'oursignal/scheme'
require 'oursignal/scheme/link'
require 'oursignal/scheme/timestep'

module Oursignal
  class Scheme
    class Score < Scheme
      store :scores
      attribute :timestep_id,       Swift::Type::Integer, key: true
      attribute :link_id,           Swift::Type::Integer, key: true
      attribute :score_delicious,   Swift::Type::Float,   default: 0
      attribute :score_digg,        Swift::Type::Float,   default: 0
      attribute :score_facebook,    Swift::Type::Float,   default: 0
      attribute :score_frequency,   Swift::Type::Float,   default: 0
      attribute :score_freshness,   Swift::Type::Float,   default: 0
      attribute :score_googlebuzz,  Swift::Type::Float,   default: 0
      attribute :score_reddit,      Swift::Type::Float,   default: 0
      attribute :score_twitter,     Swift::Type::Float,   default: 0
      attribute :score_ycombinator, Swift::Type::Float,   default: 0
      attribute :score,             Swift::Type::Float,   default: 0
      attribute :ema,               Swift::Type::Float,   default: 0
      attribute :velocity,          Swift::Type::Float,   default: 0

      def timestep; Timestep.get(id: timestep_id) end
      def link;     Link.get(id: link_id)         end
    end # Entry
  end # Scheme
end # Oursignal

