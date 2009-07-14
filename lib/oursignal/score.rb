require 'eventmachine'
require 'oursignal/score/cache'
require 'oursignal/score/cache/digg'
require 'oursignal/score/tally'

module Oursignal
  module Score
    def self.run
      Signal.trap('INT'){ puts '' && EM.stop}
      EM.run do
        Oursignal::Score::Cache.subclasses.each(&:run)
        Oursignal::Score::Tally.run
      end
    end
  end # Score
end # Oursignal
