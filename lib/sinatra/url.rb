require 'uri/domain'
module Sinatra
  class Base

    # Sinatra URL helpers.
    module Url
      #--
      # TODO: Encoding.
      def url *path
        params = path[-1].respond_to?(:to_hash) ? path.delete_at(-1).to_hash : {}
        params = params.empty? ? '' : '?' + URI.escape(params.map{|*a| a.join('=')}.join('&')).to_s
        '/' + path.compact.map(&:to_s).join('/') + params
      end

      def absolute_url *path
        port = request.port == 80 ? '' : ":#{request.port}"
        request.scheme + '://' + request.host + port + url(*path)
      end

      # TODO better way to handle shit urls.
      def domain url
        domain = URI.parse(url.sub(%r{[?#].*$}, '').gsub(/\s/, '+')).domain rescue nil
        domain || url.scan(%r{https?://([^/]+)}).first
      end
    end # Url

    helpers Url
  end # Base
end # Sinatra
