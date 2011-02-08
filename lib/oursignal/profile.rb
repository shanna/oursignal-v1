require 'digest/sha1'

# Business.
require 'oursignal/feed'
require 'oursignal/feed/discover'

# Schema.
require 'oursignal/scheme/user'

module Oursignal
  module Profile
    RESERVED_USERNAMES = %w{
      rss static user admin monit
      login signup openid recover password
      art css js theme
      favicon robot
      default index main root owner webmaster stateless
    }.freeze

    DEFAULT_FEEDS = {
      'http://digg.com/news.rss'                  => 0.2,
      'http://www.reddit.com/.rss'                => 0.7,
      'http://feeds.delicious.com/v2/rss/popular' => 0.6,
      'http://news.ycombinator.com/rss'           => 0.3,
    }.freeze

    class << self
      #--
      # TODO: Reserved usernames.
      def create options = {}
        options[:password] = digest_password options[:password] # TODO: Fugly.
        Oursignal.db.transaction :profile_create do
          user = Scheme::User.create(options).first
          DEFAULT_FEEDS.each do |url, score|
            feed = Oursignal::Feed.discover url
            Scheme::UserFeed.create(user_id: user.id, feed_id: feed.id)
          end
          user
        end
      end

      def authenticate identifier, password
        Oursignal::Scheme::User.first 'password = ? and (username = ? or email = ?)', digest_password(password), identifier, identifier
      end

      def update options = {}
        raise NotImplementedError
      end

      #--
      # TODO: Update recovery digest.
      # TODO: Queue email.
      def recover identifier
        raise NotImplementedError
      end

      def search identifier
        Oursignal::Scheme::User.first 'username = ? or email = ?', identifier, identifier
      end

      private
        def digest_password password
          Digest::SHA1.hexdigest('some salt' + password.to_s)
        end
    end
  end # Profile
end #Oursignal

