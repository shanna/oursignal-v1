require 'eventmachine'
require 'oursignal/score/source'
require 'oursignal/score/source/digg'
require 'oursignal/score/update'

module Oursignal
  module Score
    def self.run
      Signal.trap('INT'){ puts '' && EM.stop}
      EM.run do
        Oursignal::Score::Source.subclasses.each(&:run)
        Oursignal::Score::Update.run
      end
    end
  end # Score
end # Oursignal
