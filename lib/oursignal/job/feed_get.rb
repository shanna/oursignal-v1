require 'curb'
require 'digest/md5'
require 'fileutils'
require 'zlib'

# Business.
require 'oursignal/feed'

module Oursignal
  module Job
    class FeedGet
      USER_AGENT = 'oursignal-rss/0.2 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :feed_get

      class << self
        def perform original_url
          url  = URI.sanitize(original_url).to_s
          feed = Oursignal::Feed.search(url) or return

          curl = http_get url, feed
          case curl.response_code.to_s
            when /^5/
              # TODO: Delay retrying.
            when /^4/
              # TODO: Delete feed?
            when /^3/
              # Nothing, it's up to date.
            when /^2/
              etag          = etag_from_header(curl.header_str)
              last_modified = last_modified_from_header(curl.header_str)
              feed.update(last_modified: last_modified, etag: etag)

              dir  = File.join Oursignal.root, 'tmp', 'rss'
              path = File.join dir, Digest::MD5.hexdigest(url)
              FileUtils.mkdir_p(dir)
              File.open(path, 'w+'){|fh| fh.write force_encoding(decompress(curl))}
              Resque::Job.create :feed, 'Oursignal::Job::Feed', url, path
          end
        end

        protected
          def http_get uri, feed = nil
            Curl::Easy.perform(uri) do |easy|
              easy.follow_location = true

              easy.headers['User-Agent']        = USER_AGENT
              easy.headers['Accept-encoding']   = 'gzip'
              easy.headers['If-Modified-Since'] = feed.last_modified if feed && feed.last_modified
              easy.headers['If-None-Match']     = feed.etag          if feed && feed.etag
            end
          end

          def decompress curl
            if curl.header_str.match(/Content-Encoding: gzip/)
              begin
                gz   = Zlib::GzipReader.new(StringIO.new(curl.body_str))
                body = gz.read
                gz.close
                body
              rescue Zlib::GzipFile::Error
                curl.body_str
              end
            else
              curl.body_str
            end
          end

          def force_encoding raw
            options = {invalid: :replace, undef: :replace}
            raw.valid_encoding? ? raw.encode('utf-8', options) : raw.force_encoding('utf-8').encode('utf-8', options)
          rescue => error
            warn error.message
            ''
          end

          def etag_from_header(header)
            header =~ /.*ETag:\s(.*)\r/
            $1
          end

          def last_modified_from_header(header)
            header =~ /.*Last-Modified:\s(.*)\r/
            Time.parse($1) if $1
          end
      end
    end # CalendarGet
  end # Job
end # Oursignal

