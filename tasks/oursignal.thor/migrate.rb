require File.join(File.dirname(__FILE__), 'common')

module Oursignal
  class Migrate < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'user', '(Re)create default oursignal user'
    def user
      user = User.first(:conditions => {:username => 'oursignal'}) || User.create(
        :username => 'oursignal',
        :fullname => 'OurSignal',
        :email    => 'enquiries@oursignal.com'
      )

      user.user_feeds = []
      {
        'http://feeds.digg.com/digg/popular.rss'    => 1,
        'http://www.reddit.com/.rss'                => 0.7,
        'http://feeds.delicious.com/v2/rss/popular' => 0.6,
        'http://news.ycombinator.com/rss'           => 0.3,
      }.map do |url, score|
        link = Link.discover(url)
        unless feed = user.feed(link.url)
          user.user_feeds << UserFeed.new(:url => link.url, :score => score)
        end
      end

      user.save
    end
  end
end
