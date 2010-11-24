require 'oursignal/user'
require 'oursignal/feed'

module Oursignal
  class UserFeed < Swift::Scheme
    store :user_feeds
    attribute :user_id, Swift::Type::Integer, key: true
    attribute :feed_id, Swift::Type::Integer, key: true

    def user; Oursignal::User.get(user_id) end
    def feed; Oursignal::Feed.get(feed_id) end
  end # UserFeed
end # Oursignal
