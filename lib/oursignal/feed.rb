require 'schedule'
require 'oursignal/feed/update'
require 'oursignal/feed/expire'

module Oursignal
  module Feed
    def self.run
      Schedule.run do
        Update.run
        Expire.run
      end
    end
  end # Feed
end # Oursignal

