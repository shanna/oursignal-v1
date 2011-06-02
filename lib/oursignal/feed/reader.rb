require 'curb'
require 'time'
require 'zlib'

# Business.
require 'oursignal/feed'
require 'oursignal/feed/parser'

module Oursignal
  class Feed
    module Reader
      def self.perform
        feeds = Feed.execute(%q{
          select * from feeds
          where updated_at < now() - interval '5 minutes'
        })

        # TODO: Safe distance from (ulimit -n) - (lsof | wc -l)
        multi = Curl::Multi.new
        multi.max_connects = 250
        feeds.each do |feed|
          easy = Curl::Easy.new(feed.url) do |e|
            e.follow_location              = true
            e.timeout                      = 5
            e.headers['User-Agent']        = Oursignal::USER_AGENT
            e.headers['If-Modified-Since'] = feed.last_modified if feed.last_modified
            e.headers['If-None-Match']     = feed.etag          if feed.etag

            e.on_complete do |response|
              begin
                status = response.response_code.to_s
                feed.update(
                  etag:          etag(response),
                  last_modified: last_modified(response),
                  updated_at:    Time.now
                ) if status =~ /^[23]/

                return unless status =~ /^2/
                parser = Oursignal::Feed::Parser.find(feed) || return
                parser.new(feed).parse(force_utf8(body(response)))
              rescue => error
                warn error.inspect
              end
            end
          end
          multi.add easy
        end
        multi.perform
      end

      protected
        def self.etag curl
          curl.header_str =~ /.*ETag:\s(.*)\r/
          $1
        end

        def self.last_modified curl
          curl.header_str =~ /.*Last-Modified:\s(.*)\r/
          Time.parse($1) if $1
        end

        def self.body curl
          if curl.header_str.match(/.*Content-Encoding:\sgzip\r/)
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

        #--
        # TODO: Steal code from https://github.com/stateless-systems/metauri/blob/master/lib/metauri/location/resolve.rb
        def self.force_utf8 raw
          options = {invalid: :replace, undef: :replace}
          raw.valid_encoding? ? raw.encode('utf-8', options) : raw.force_encoding('utf-8').encode('utf-8', options)
        rescue => error
          warn error.message
          ''
        end

    end # Reader
  end # Feed
end # Oursignal
