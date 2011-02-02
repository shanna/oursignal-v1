require 'digest/sha1'

# Schema.
require 'oursignal/scheme/feed'
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
      # TODO: Create new User.
      # TODO: Add default feeds.
      def create options = {}
        user = Oursignal::Scheme::User.create options
        # TODO: Queue feed discovery for default feeds.
        # TODO: Add user_feeds.
        user
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

