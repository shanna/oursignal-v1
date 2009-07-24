require File.join(File.dirname(__FILE__), 'helper')

class LinkTest < ModelTest
  context 'Link' do
    setup do
      Link.destroy_all
    end

    context '#discover url' do
      should 'raise error on non http url' do
        assert_raises(MongoMapper::DocumentNotValid){ Link.discover('asdf')}
        assert_raises(MongoMapper::DocumentNotValid){ Link.discover('ftp://localhost')}
      end

      should 'create new feed link' do
        assert link = Link.discover(feed_url)
        assert_kind_of MongoMapper::Document, link
      end

      should 'return existing feed link if it exists already' do
        link = Link.discover(feed_url)
        assert_equal link, Link.discover(link.url)
      end

      should 'return new feed link if other links exist already' do
        first  = Link.discover(feed_url)
        second = Link.discover(feed_url('http://rss.slashdot.org/Slashdot/slashdot'))
        assert_not_equal first, second
      end
    end

    context '.selfupdate' do
      setup do
        @feed ||= Link.discover(feed_url)
      end

      should 'not raise errors' do
        assert_nothing_raised do
          @feed.selfupdate
        end
      end

      should 'populate links' do
        @feed.selfupdate
        assert Link.all(:conditions => {:referrers => [@feed.url]}).size > 1
      end

      should 'return only feed' do
        @feed.selfupdate
        sleep 5

        links = Link.all(:conditions => {:feed => {:'$ne' => {}}})
        assert_equal 1, links.size
      end

      should 'return only feed after multiple updates' do
        @feed.selfupdate
        sleep 5

        @feed.selfupdate
        sleep 5

        links = Link.all(:conditions => {:feed => {:'$ne' => {}}})
        assert_equal 1, links.size
      end
    end

    context '.feed' do
      should 'return new feed object' do
        assert_kind_of LinkFeed, Link.new.feed
      end
    end

    context '.score' do
      should 'return new score object' do
        assert_kind_of LinkScore, Link.new.score
      end
    end
  end

  private
    def feed_url(url = 'http://feeds2.feedburner.com/Rubyflow')
      url
    end
end
