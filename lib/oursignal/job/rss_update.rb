require 'fileutils'
require 'feed_me'
require 'oursignal/job'
require 'oursignal/feed'

module Oursignal
  module Job
    #--
    # TODO: Stream the feed file in.
    class RssUpdate
      extend Resque::Plugins::Lock
      @queue = :rss_update

      class << self
        def perform url, path
          begin
            feed = Oursignal::Feed.search(url) or return
            fm   = FeedMe.parse(File.open(path))

            feed.update(title: fm.title, site: URI.sanitize(fm.url).to_s)
            fm.entries.each do |entry|
              attributes = {title: entry.title, url: entry.url, content: entry.content}
              Resque::Job.create :rss_entry_update, 'Oursignal::Job::RssEntryUpdate', url, attributes
            end
            FileUtils.rm(path)
          rescue FeedMe::InvalidFeedFormat
            warn 'Not an RSS/Atom feed.'
            FileUtils.rm(path) # TODO: Later pop this in an ensure?
          end
        end
      end
    end # RssUpdate
  end # Job
end # Oursignal
