module Oursignal
  class Theme < Swift::Scheme
    store :themes
    attribute :id,   Swift::Type::Integer, serial: true, key: true
    attribute :name, Swift::Type::String
  end
end
