require 'oursignal/scheme'

module Oursignal
  class Scheme
    class Timestep < Scheme
      store :timesteps
      attribute :id,          Swift::Type::Integer, serial: true, key: true
      attribute :created_at,  Swift::Type::Time,    default: proc{ Time.now }
    end # Timestep
  end # Scheme
end # Oursignal

