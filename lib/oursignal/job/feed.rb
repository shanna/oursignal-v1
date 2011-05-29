require 'nokogiri'
require 'oursignal/feed'
require 'oursignal/feed/parser'
require 'oursignal/job'

module Oursignal
  module Job
    class Feed
      extend Resque::Plugins::Lock
      @queue = :feed

      class << self
        # TODO: Error handling.
        def perform feed_id, path
          feed   = Oursignal::Feed.get(id: feed_id) || return
          parser = Oursignal::Feed::Parser.find(feed)    || return
          parser.new(feed).parse(File.open(path))

          # XXX: Don't unlink feeds for now.
          # File.unlink(path)
        end
      end
    end # Feed
  end # Job
end # Oursignal
