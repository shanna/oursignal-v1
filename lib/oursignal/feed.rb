# Schema.
require 'oursignal/scheme/feed'

module Oursignal
  module Feed
    def self.search identifier
      Oursignal::Scheme::Feed.first 'url = ?', identifier
    end
  end # Feed
end # Oursignal

