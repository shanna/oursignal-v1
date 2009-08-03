require 'eventmachine'
require 'oursignal/score/source'
require 'oursignal/score/source/digg'
require 'oursignal/score/source/reddit'
require 'oursignal/score/source/delicious'
require 'oursignal/score/source/ycombinator'
require 'oursignal/score/update'
require 'oursignal/score/expire'

module Oursignal
  module Score
    def self.run
      DataMapper.logger.level = Merb::Logger::Levels[:error]
      Signal.trap('INT'){ puts '' && EM.stop}
      EM.run do
        Oursignal::Score::Source.subclasses.each(&:run)
        Oursignal::Score::Update.run
        Oursignal::Score::Expire.run
      end
    end
  end # Score
end # Oursignal
