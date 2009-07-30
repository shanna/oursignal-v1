require File.join(File.dirname(__FILE__), 'helper')
require 'uri/redirect'

class URIRedirectTest < MerbTest
  context 'URI' do
    should 'have URI::Redirect mixed in' do
      assert_kind_of URI::Redirect, uri
    end

    should 'respond to follow' do
      assert uri.respond_to?(:follow)
      assert uri.respond_to?(:follow!)
    end

    should 'follow without error' do
      assert_nothing_raised{ uri.follow}
    end

    should 'return URI object' do
      assert_kind_of URI, uri.follow
    end

    should 'return same uri without redirect' do
      assert_equal uri.to_s, uri.follow.to_s
    end

    should 'return different uri on redirect' do
      # TODO: Only works outside US. Make a more reliable 30x request.
      assert_not_same 'google.com', uri('google.com').follow.to_s
    end

    should 'return same url on 404' do
      url = uri('http://www.google.com/asdf')
      assert_equal url.to_s, url.follow.to_s
    end
  end

  protected
    def uri(uri = 'http://oursignal.com')
      URI.parse(uri)
    end
end
