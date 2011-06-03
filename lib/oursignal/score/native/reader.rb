require 'curb'
require 'time'
require 'zlib'

# Business.
require 'oursignal/link'
require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      module Reader
        def self.perform
          sources = Oursignal::Score::Native.all
          links   = Link.execute(%q{
            select * from links
            -- where updated_at < now() - interval '5 minutes'
            limit 1
          })

          # TODO: Safe distance from (ulimit -n) - (lsof | wc -l)
          multi = Curl::Multi.new
          multi.max_connects = 250
          sources.each do |source|
            links.each do |link|
              score = source.new(link)
              easy  = Curl::Easy.new(score.url) do |e|
                e.follow_location       = true
                e.timeout               = 5
                e.headers['User-Agent'] = Oursignal::USER_AGENT
                e.on_complete do |response|
                  begin
                    score.parse(force_utf8(body(response))) if response.response_code.to_s =~ /^2/
                  rescue => error
                    warn [error.message, *error.backtrace].join("\n")
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
            warn error.message
            ''
          end

      end # Reader
    end # Native
  end # Score
end # Oursignal

