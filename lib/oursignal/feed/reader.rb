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
        # multi = Curl::Multi.new
        # multi.max_connects = 250
        sources.each do |source|
          parser = source.new
          parser.urls.each do |url|
            # puts '---', url.to_s
            easy = Curl::Easy.new(url) do |e|
              e.resolve_mode          = :ipv4 # IPv6 has issues on some sites!?
              e.verbose               = true  # XXX: Debug.
              e.follow_location       = true
              e.timeout               = 60    # reddit and ycombinator can be slow as fuck.
              e.headers['User-Agent'] = Oursignal::USER_AGENT

              e.on_complete do |response|
                begin
                  #puts 'feed:(%s) %d %4.2fkb %4.2fkb/s' % [
                  #  response.url,
                  #  response.response_code,
                  #  response.downloaded_bytes / 1024,
                  #  response.download_speed / 1024
                  #]
                  parser.parse(force_utf8(body(response))) if response.response_code.to_s =~ /^2/
                rescue => error
                  warn ['Feed Reader GET Error:', url.to_s, error.message, *error.backtrace].join("\n")
                end
              end

              e.on_failure do |response, code|
                warn ['Feed Reader GET Error:', url.to_s, code].join("\n")
              end
            end
            easy.perform
            # multi.add easy
          end
        end
        # multi.perform
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
