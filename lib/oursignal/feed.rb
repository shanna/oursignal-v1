require 'eventmachine'
require 'oursignal/feed/update'
require 'oursignal/feed/expire'

module Oursignal
  module Feed
    def self.run
      DataMapper.logger.level = Merb::Logger::Levels[:error]
      Signal.trap('INT'){ puts '' && EM.stop}
      EM.run do
        Oursignal::Feed::Update.run
        Oursignal::Feed::Expire.run
      end
    end
  end # Feed
end # Oursignal

