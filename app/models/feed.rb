class Feed < Link
  key :etag,          String
  key :last_modified, Time
  key :links,         Array

  USER_AGENT = 'oursignal-rss/2 +oursignal.com'
  def self.selfupdate
    opts = {
      :user_agent => USER_AGENT,
      :on_success => method(:update),
    }
    opts[:if_modified_since] = feed[:last_modified] unless last_modified.blank?
    opts[:if_none_match]     = feed[:etag] unless etag.blank?

    # TODO: 302 handling and such.
    Feedzirra::Feed.fetch_and_parse(url, opts)
  end

  def self.update(url, remote_feed)
    remote_feed.sanitize_entries!
=begin
    entries = remote_feed.entries.map do |entry|
      {
        :guid      => entry.id,
        :title     => entry.title,
        :url       => entry.url,
        :published => entry.published
      }.to_mongo
    end

    repsert({:url => url}.to_mongo,
      r = {
        :title         => remote_feed.title,
        :site          => remote_feed.url,
        :etag          => remote_feed.etag,
        :last_modified => remote_feed.last_modified,
        :entries       => entries,
        :updated_at    => Time.now
      }.to_mongo
    )
=end
  end

  def self.discover(url)
    uri = URI.parse(Addressable::URI.heuristic_parse(url, {:scheme => 'http'}).normalize!)
    raise MongoMapper::DocumentNotValid.new("That's no URI: '#{uri}'") unless URI::HTTP < uri

    uri     = uri.to_s
    primary = Columbus.new(uri).primary
    url     = {:url => primary.nil? ? uri : primary.url.to_s}
    unless first(url)
      feed = create(url)
      feed.selfupdate #??
      feed
    end
  end
end # Feed

