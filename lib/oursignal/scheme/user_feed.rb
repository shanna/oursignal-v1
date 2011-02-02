require 'oursignal/scheme'
require 'oursignal/scheme/user'
require 'oursignal/scheme/feed'

module Oursignal
  class Scheme
    class UserFeed < Scheme
      store :user_feeds
      attribute :user_id, Swift::Type::Integer, key: true
      attribute :feed_id, Swift::Type::Integer, key: true

      def user; Oursignal::Scheme::User.get(user_id) end
      def feed; Oursignal::Scheme::Feed.get(feed_id) end
    end # UserFeed
  end # Scheme
end # Oursignal
