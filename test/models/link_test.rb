require File.join(File.dirname(__FILE__), 'helper')

class LinkTest < ModelTest
  context Link do
    setup do
      Link.destroy_all
    end

    context '#discover url' do
      should 'raise error on non http url' do
        assert_raises(MongoMapper::DocumentNotValid){ Link.discover('asdf')}
        assert_raises(MongoMapper::DocumentNotValid){ Link.discover('ftp://blah')}
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
  end

  private
    def feed_url(url = 'http://feeds2.feedburner.com/Rubyflow')
      url
    end
end
