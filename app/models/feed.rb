class Feed
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
    feed = self.update(
        {:url => url}.to_mongo,
        {
          :title        => remote_feed.title,
          :site          => remote_feed.site,
          :etay          => remote_feed.etag,
          :last_modified => remote_feed.last_modified
        }.to_mongo
    )
    # TODO: Items.update(feed, remote_feed.entries)
  end

  private
=begin
    # TODO: Something like this.
    def discover_feed
      primary = Columbus.new(self.url).primary
      self.url = primary.nil? ? self.url : primary.url
      true
    rescue
      false
    end
=end
end # Feed

