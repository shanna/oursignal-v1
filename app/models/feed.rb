class Feed
  include Merb::ControllerExceptions # No merb_mongo yet.
  include Mongo::Resource

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'
  def self.selfupdate(url)
    feed = find_first({:url => url}.to_mongo) || return
    opts = {
      :user_agent => USER_AGENT,
      :on_success => method(:update)
      # :on_failure
    }
    opts[:if_modified_since] = feed[:last_modified] unless feed[:last_modified].blank?
    opts[:if_none_match]     = feed[:etag] unless feed[:etag].blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, opts)
  end

  def self.update(url, remote_feed)
    url = {:url => url}.to_mongo
    begin
      # TODO: Map feeds.
      feed = repsert(url,
        {
          :title         => remote_feed.title,
          :site          => remote_feed.url,
          :etag          => remote_feed.etag,
          :last_modified => remote_feed.last_modified,
          :updated_at    => Time.now
        }.to_mongo
      )
    rescue => e
      modify(url, :updated_at => Time.now)
    end
  end

  def self.discover(url)
    uri = URI.parse(Addressable::URI.heuristic_parse(url, {:scheme => 'http'}).normalize!)
    raise(BadRequest, "That's no URI: '#{url}'") unless uri && uri.kind_of?(URI::HTTP)

    uri     = uri.to_s
    primary = Columbus.new(uri).primary
    feed    = {:url => primary.nil? ? uri : primary.url.to_s}.to_mongo
    find_first(feed) || (insert(feed) && selfupdate(uri))
  end
end # Feed

