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
        request.scheme + '://' + request.host + url(*path)
      end
    end # Url

    helpers Url
  end # Base
end # Sinatra
