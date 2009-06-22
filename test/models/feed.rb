require File.join(File.dirname(__FILE__), 'helper')

class FeedTest < ModelTest
  context Feed do
    setup do
      Feed.clear
    end

    should 'discover feed' do
      assert feed = Feed.discover(feed_url)
    end
  end

  private
    def feed_url(url = 'http://feeds2.feedburner.com/Rubyflow')
      url
    end
end
