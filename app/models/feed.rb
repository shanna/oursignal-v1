class Feed
  include Merb::ControllerExceptions # No merb_mongo yet.
  include Mongo::Resource

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'
  def selfupdate
    opts = {
      :user_agent => USER_AGENT,
      :on_success => self.class.method(:update)
      # :on_failure
    }
    opts[:if_modified_since] = last_modified unless last_modified.blank?
    opts[:if_none_match]     = etag unless etag.blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, opts)
  end

  def self.update(url, remote_feed)
    feed = update(
        {:url => url}.to_mongo,
        {
          :title         => remote_feed.title,
          :site          => remote_feed.site,
          :etay          => remote_feed.etag,
          :last_modified => remote_feed.last_modified
        }.to_mongo
    )
    # TODO: Items.update(feed, remote_feed.entries)
  end

  def self.discover(url)
    uri = URI.parse(Addressable::URI.heuristic_parse(url, {:scheme => 'http'}).normalize!)
    raise(BadRequest, "That's no URI: '#{url}'") unless uri && uri.kind_of?(URI::HTTP)

    primary = Columbus.new(url.to_s).primary
    repsert({:url => primary.url}.to_mongo, {:url => primary.url}.to_mongo)
  end
end # Feed

