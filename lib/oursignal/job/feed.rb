require 'oursignal/feed'
require 'oursignal/feed/reader'
require 'oursignal/job'

module Oursignal
  module Job
    class Feed
      extend Resque::Plugins::Lock
      @queue = :feed

      def self.perform
        Oursignal::Feed::Reader.perform
      end
    end # Feed
  end # Job
end # Oursignal

