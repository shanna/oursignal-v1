require 'curb'
require 'digest/md5'
require 'fileutils'
require 'zlib'

# Business.
require 'oursignal/feed'

module Ev
  module Job
    class RssGet
      USER_AGENT = 'oursignal-rss/0.2 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :rss_get # Yick, really?

      class << self
        #--
        # TODO: Error handling.
        def perform original_url
          url  = URI.sanitize(original_url).to_s
          dir  = File.join Ev.root, 'tmp', 'rss'
          path = File.join dir, Digest::MD5.hexdigest(url)
          curl = http_get url, Oursignal::Feed.search(url)

          FileUtils.mkdirs(dir)
          File.open(path, 'w+'){|fh| fh.write force_encoding(decompress(curl))}
          Resque.enqueue(Ev::Job::RssUpdate, url, path)
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
            raw.valid_encoding? ? raw.encode('utf-8') : raw.force_encoding('utf-8').encode('utf-8')
          rescue
            ''
          end
      end
    end # CalendarGet
  end # Job
end # Ev

