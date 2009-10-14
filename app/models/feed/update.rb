class Feed
  module Update
    USER_AGENT = 'oursignal-rss/2 +oursignal.com'

    def selfupdate
      success, feed = *fetch_and_parse
      if success && feed != 304
        # The order of stuff is very important here.
        self.title         = feed.title
        self.site          = URI.sanatize(feed.url) if site.blank? && !feed.url.blank?
        self.etag          = feed.etag
        self.last_modified = feed.last_modified.to_datetime unless feed.last_modified.blank?
        self.updated_at    = DateTime.now

        if !new? || save
          feed.entries.each{|entry| Link.discover(self, entry)}
          self.total_links = FeedLink.count(:feed => self)
          age              = ((updated_at.to_time - created_at.to_time).to_f / 1.day).to_i
          self.daily_links = age >= 1 ? (total_links.to_f / age).round(2) : total_links
        end
      end
    rescue
      DataMapper.logger.error("feed\terror\n#{$!.message}\n#{$!.backtrace}")
    ensure
      self.updated_at = DateTime.now
      return save
    end

    def fetch_and_parse
      options                     = {:user_agent => USER_AGENT, :timeout => 5}
      options[:if_modified_since] = last_modified.to_time unless last_modified.blank?
      options[:if_none_match]     = etag unless etag.blank?

      case feed = Feedzirra::Feed.fetch_and_parse(url.to_s, options)
        when Feedzirra::Parser::RSS, Feedzirra::Parser::Atom, 304 then [true, feed]
        when nil                                                  then [false, 'Not an RSS feed']
        when 0                                                    then [false, 'Timed out']
        when Fixnum                                               then [false, "Returned #{feed} status"]
        else [false, 'Not an RSS feed?']
      end
    rescue
      [false, "Read error, no response from site."]
    end
  end # Update
end # Feed
