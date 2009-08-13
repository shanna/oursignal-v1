require File.join(File.dirname(__FILE__), 'helper')

class FeedTest < ModelTest
  context 'Feed' do
    context '#discover url' do
      should 'have validation error on non url' do
        assert feed = Feed.discover('asdf')
        assert_kind_of Feed, feed
        assert !feed.valid?(:discover)
      end

      should 'have validation error on non http url' do
        assert feed = Feed.discover('ftp://localhost')
        assert_kind_of Feed, feed
        assert !feed.valid?(:discover)
      end

      should 'create new feed' do
        assert feed = Feed.discover(feed_url)
        assert_kind_of Feed, feed
        assert feed.valid?(:discover)
      end

      should 'return existing feed link if it exists already' do
        link = Feed.discover(feed_url)
        assert_equal link, Feed.discover(link.url)
      end

      should 'return new feed if other feeds exist already' do
        first  = Feed.discover(feed_url)
        second = Feed.discover(feed_url('http://rss.slashdot.org/Slashdot/slashdot'))
        assert_not_equal first, second
      end
    end

    context '.selfupdate' do
      setup do
        @feed ||= Feed.discover(feed_url)
      end

      should 'not raise errors' do
        assert_nothing_raised do
          @feed.selfupdate
        end
      end

      should 'populate links' do
        @feed.selfupdate
        assert_not_equal [], @feed.links

        links = @feed.links.sort{|a, b| a.title <=> b.title}
        all   = Link.all.sort{|a, b| a.title <=> b.title}
        assert_equal links, all
      end
    end
  end

  private
    def feed_url(url = 'http://feeds2.feedburner.com/Rubyflow')
      url
    end
end
