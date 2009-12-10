require 'oursignal/job'
require 'uri/sanatize'
require 'open-uri'
require 'zlib'

module Oursignal
  module Score

    class Source < Job
      def call
        Merb.logger.info("#{name}\tupdating cache")
        data = http_read(http_uri)
        work(data) unless data.blank?
      end

      def uri(address, params = nil)
        uri = Addressable::URI.parse(address)
        uri.query_values = params if params && uri
        uri
      end

      def score(*args)
        name, url, score = (args.size == 3 ? args : args.unshift(self.class.name))
        begin
          # TODO: REPLACE INTO:
          options = {:url => URI.sanatize(url), :source => name}
          if sc = ::Score.first(options)
            sc.update(:score => score)
          else
            ::Score.create(options.update(:score => score))
          end
          Merb.logger.debug("%s\t%.5f\t%s" % [name, score, url])
        rescue DataObjects::IntegrityError
          # Ignore. It's a tiny race condition.
        rescue URI::Error
          # Ignore.
        rescue Exception => error
          Merb.logger.error(
            "%s\terror\t%s\n%s\n%s" % [name, error.class.to_s.downcase, error.message, error.backtrace.join($/)]
          )
        end
      end

      def work(data = nil)
        raise NotImplementedError
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
          {'User-Agent' => 'oursignal-rss/2 +oursignal.com', 'Accept-Encoding' => 'gzip'}
        end

        # Generate a URI, Addressable::URI or just a string URI to read from.
        def http_uri
          raise NotImplementedError
        end
    end # Source
  end # Score
end # Oursignal

