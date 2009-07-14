require 'oursignal/job'
require 'open-uri'
require 'zlib'

module Oursignal
  module Score

    class Cache < Job
      def poll
        begin
          timeout(10){ content = http_read(http_uri)}
        rescue Timeout::Error => e
          content = nil
          # TODO: Error message.
        end
        content
      end

      def uri(address, params = nil)
        uri = Addressable::URI.parse(address)
        uri.query_values = params if params && uri
        uri
      end

      protected
        # Read http_uri and return the response body.
        def http_read(uri)
          content, encoding = '', ''
          begin
            res = open(uri.to_s, http_read_options)
            if res.meta['content-encoding'] == 'gzip'
              encoding = 'GZ '
              gz       = Zlib::GzipReader.new(res)
              content  = gz.read
              gz.close
            # TODO: when 'deflate'
            else
              content = res.read
            end
          rescue URI::InvalidURIError
            content = ''
          end
          content
        end

        # Options that will be passed to open() when requesting the data.
        def http_read_options
          {'User-Agent' => Link::USER_AGENT, 'Accept-Encoding' => 'gzip'}
        end

        # Generate a URI, Addressable::URI or just a string URI to read from.
        def http_uri
          raise NotImplementedError
        end
    end # Cache
  end # Score
end # Oursignal

