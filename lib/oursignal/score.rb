require 'schedule'
require 'oursignal/score/source'
require 'oursignal/score/source/digg'
require 'oursignal/score/source/reddit'
require 'oursignal/score/source/delicious'
require 'oursignal/score/source/ycombinator'
require 'oursignal/score/source/freshness'
require 'oursignal/score/update'
require 'oursignal/score/expire'

module Oursignal
  module Score
    def self.run
      Schedule.run do
        Source.subclasses.each(&:run)
        Update.run
        Expire.run
      end
    end
  end # Score
end # Oursignal
