require 'oursignal'

module Oursignal
  module Score
    class Source
      class Freshness < Source
        def call
          system File.join(Oursignal.root, 'bin', 'freshness')
          system File.join(Oursignal.root, 'bin', 'frequency')
        end
      end # Freshness
    end # Source
  end # Score
end # Oursignal

