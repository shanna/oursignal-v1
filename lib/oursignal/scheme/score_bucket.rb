require 'oursignal/scheme'
require 'swift/type/array'

module Oursignal
  class Scheme
    class ScoreBucket < Scheme
      store :score_buckets
      attribute :source,  Swift::Type::String, key: true
      attribute :buckets, Swift::Type::FloatArray
    end # ScoreBucket
  end # Scheme
end # Oursignal

