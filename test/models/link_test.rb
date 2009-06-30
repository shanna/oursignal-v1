require File.join(File.dirname(__FILE__), 'helper')

class LinkTest < ModelTest
  context Link do
    setup do
      Link.destroy_all
    end

    should 'discover feed' do
      assert feed = Link.discover(feed_url)
    end
  end

  private
    def feed_url(url = 'http://feeds2.feedburner.com/Rubyflow')
      url
    end
end
