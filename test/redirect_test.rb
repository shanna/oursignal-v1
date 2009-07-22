require File.join(File.dirname(__FILE__), 'helper')
require 'uri/redirect'
require 'moneta/mongodb'

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

    should 'use mongo cache' do
      begin
        db         = MongoMapper.database
        collection = db.collection('uri_redirect_cache')
        collection.drop

        URI::Redirect::Cache.moneta = Moneta::MongoDB.new(:db => db.name, :collection => collection.name)
        assert_equal 0, collection.count

        uri.follow
        assert_equal 1, collection.count
      ensure
        URI::Redirect::Cache.moneta = Moneta::Memory.new
      end
    end
  end

  protected
    def uri(uri = 'http://oursignal.com')
      URI.parse(uri)
    end
end
