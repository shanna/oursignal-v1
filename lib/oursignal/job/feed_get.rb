require 'digest/md5'
require 'fileutils'
require 'oursignal/job'
require 'uri/io'

# Business.
require 'oursignal/feed'

module Oursignal
  module Job
    class FeedGet
      USER_AGENT = 'oursignal/0.3 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :feed_get

      #--
      # TODO: Error handling.
      def self.perform feed_id
        feed = Oursignal::Feed.get(id: feed_id) || return
        uri  = URI::IO.open(feed.url) do |io|
          io.follow_location = true
          io.timeout         = 10

          io.headers['User-Agent']        = USER_AGENT
          io.headers['If-Modified-Since'] = feed.last_modified if feed.last_modified
          io.headers['If-None-Match']     = feed.etag          if feed.etag
        end

        case uri.status.to_s
          when /^5/
            # TODO: Delay retrying.
          when /^4/
            # TODO: Delete feed?
          when /^3/
            # Nothing, it's up to date.
          when /^2/
            feed.update(last_modified: uri.last_modified, etag: uri.etag)

            dir  = File.join Oursignal.root, 'tmp', 'feed'
            path = File.join dir, Digest::MD5.hexdigest(feed.url)
            FileUtils.mkdir_p(dir)
            File.open(path, 'w+'){|fh| fh.write uri.read}
            Resque::Job.create :feed, 'Oursignal::Job::Feed', feed.id, path
        end
      end
    end # FeedGet
  end # Job
end # Oursignal

