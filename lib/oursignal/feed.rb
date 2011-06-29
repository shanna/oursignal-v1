require 'resque'

# Schema.
require 'oursignal/scheme/feed'

module Oursignal
  class Feed < Scheme::Feed
    class << self
      def find id
        execute(%q{select * from feeds where id = ? or url = ?}, id.to_s.to_i, id).first
      end
    end
  end # Feed
end # Oursignal

