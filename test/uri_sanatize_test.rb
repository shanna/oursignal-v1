require File.join(File.dirname(__FILE__), 'helper')
require 'uri/sanatize'

class URISanatieTest < MerbTest
  context 'URI' do
    should 'set scheme' do
      assert_equal 'http', uri('oursignal.com').sanatize.scheme
    end

    should 'not raise errors' do
      assert_nothing_raised do
        uri('http://demoday.fanchatter.com/').sanatize
      end
    end

    should 'return same url' do
      url = 'http://www.jnd.org/dn.mss/being_analog.html#makesense'
      assert_equal url, URI.sanatize(url)
    end
  end

  protected
    def uri(uri = 'http://oursignal.com')
      URI.parse(uri)
    end
end
