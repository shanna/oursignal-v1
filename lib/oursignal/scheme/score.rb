require 'oursignal/scheme'
require 'oursignal/scheme/link'
require 'oursignal/scheme/timestep'

module Oursignal
  class Scheme
    class Score < Scheme
      SOURCES = [
        :score_digg,
        :score_facebook,
        :score_google,
        :score_reddit,
        :score_twitter,
        :score_ycombinator
      ]
      def self.sources
        SOURCES
      end

      store :scores
      attribute :timestep_id,       Swift::Type::Integer, key: true
      attribute :link_id,           Swift::Type::Integer, key: true
      attribute :bucket,            Swift::Type::Float,   default: 0
      attribute :score,             Swift::Type::Float,   default: 0
      attribute :ema,               Swift::Type::Float,   default: 0
      attribute :velocity,          Swift::Type::Float,   default: 0
      sources.each{|source| attribute source, Swift::Type::Float, default: 0 }

      def timestep; Timestep.get(id: timestep_id) end
      def link;     Link.get(id: link_id)         end
    end # Entry
  end # Scheme
end # Oursignal

