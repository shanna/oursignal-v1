require 'curb'
require 'time'
require 'zlib'

# Business.
require 'oursignal/feed'
require 'oursignal/feed/parser'

module Oursignal
  class Feed

    #--
    # TODO: Reader is almost identical to lib/oursignal/score/reader.rb
    module Reader
      def self.perform
        sources = Oursignal::Feed::Parser.all

        # TODO: Safe distance from (ulimit -n) - (lsof | wc -l)
        multi = Curl::Multi.new
        multi.max_connects = 250
        sources.each do |source|
          parser = source.new
          parser.urls.each do |url|
            easy = Curl::Easy.new(url) do |e|
              e.follow_location       = true
              e.timeout               = 5
              e.headers['User-Agent'] = Oursignal::USER_AGENT

              e.on_complete do |response|
                begin
                  puts 'feed:(%s) %d %4.2fkb %4.2fkb/s' % [
                    response.url,
                    response.response_code,
                    response.downloaded_bytes / 1024,
                    response.download_speed / 1024
                  ]
                  parser.parse(force_utf8(body(response))) if response.response_code.to_s =~ /^2/
                rescue => error
                  warn ['Feed Reader GET Error:', error.message, *error.backtrace].join("\n")
                end
              end
            end
            multi.add easy
          end
        end
        multi.perform
      end

      protected
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
          warn ['Feed Reader UTF-8 Error:', error.message, *error.backtrace].join("\n")
          ''
        end

    end # Reader
  end # Feed
end # Oursignal
