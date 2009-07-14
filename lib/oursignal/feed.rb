require 'eventmachine'
require 'oursignal/feed/update'

module Oursignal
  module Feed
    def self.run
      Signal.trap('INT'){ puts '' && EM.stop}
      EM.run{ Oursignal::Feed::Update.run}
    end
  end # Feed
end # Oursignal

