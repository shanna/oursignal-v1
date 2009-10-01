require File.join(File.dirname(__FILE__), 'helper')

class FeedTest < ModelTest
  context 'Feed' do
    context '#discover url' do
      should 'have validation error on non url' do
        assert feed = Feed.discover('asdf')
        assert_kind_of Feed, feed
        assert !feed.valid?(:discover)
        assert feed.new?
      end

      should 'have validation error on non http url' do
        assert feed = Feed.discover('ftp://localhost')
        assert_kind_of Feed, feed
        assert !feed.valid?(:discover)
        assert feed.new?
      end

      should 'have validation error for non existant url' do
        feed = Feed.discover('http://notadomain.local')
        assert_kind_of Feed, feed
        assert !feed.valid?(:discover)
        assert feed.new?
      end

      should 'have validation error for non rss url' do
        feed = Feed.discover('http://shanehanna.org')
        assert_kind_of Feed, feed
        assert !feed.valid?(:discover)
        assert feed.new?
      end

      should 'create new feed' do
        assert feed = Feed.discover(feed_url)
        assert_kind_of Feed, feed
        assert feed.valid?(:discover)
        assert !feed.new?
      end

      should 'return existing feed link if it exists already' do
        feed = Feed.discover(feed_url)
        assert_equal feed, Feed.discover(feed.url)
        assert !feed.new?
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

      should 'not have validation errors' do
        assert @feed.selfupdate
        assert @feed.errors.empty?
      end

      should 'populate links' do
        @feed.selfupdate
        assert_not_equal [], @feed.links
      end
    end
  end

  private
    def feed_url(url = 'http://feeds2.feedburner.com/Rubyflow')
      url
    end
end
