require 'oursignal/scheme'

module Oursignal
  class Scheme
    class Theme < Scheme
      store :themes
      attribute :id,   Swift::Type::Integer, serial: true, key: true
      attribute :name, Swift::Type::String
    end # Theme
  end # Scheme
end # Oursignal
