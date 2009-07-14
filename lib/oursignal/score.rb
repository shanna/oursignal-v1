require 'eventmachine'
require 'oursignal/score/cache'
require 'oursignal/score/cache/digg'
require 'oursignal/score/source'

module Oursignal
  module Score
    def self.run
      Signal.trap('INT'){ puts '' && EM.stop}
      EM.run do
        Oursignal::Score::Cache.subclasses.each(&:run)
        # Oursignal::Score::Cache.run
        # Oursignal::Score::Source.run
      end
    end
  end # Score
end # Oursignal
