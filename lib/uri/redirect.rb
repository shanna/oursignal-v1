require 'net/http'
require 'addressable/uri'

module URI
  module Redirect
    # --
    # TODO: This has side effects. It'll sanatize your URL even if it didn't follow a redirect at the moment.
    def follow!(*args)
      final = follow(*args)
      self.host = final.host
      self.path = final.path
    end

    # --
    # TODO: Check for circular redirects and throw a better error?
    def follow(url = self, limit = 10)
      raise 'Too many redirects' if limit == 0

      # Normalize the URI while we are here.
      uri = URI.parse(Addressable::URI.heuristic_parse(url.to_s, {:scheme => 'http'}).normalize!).to_s

      host             = Net::HTTP.new(uri.host, uri.port)
      host.use_ssl     = uri.scheme == 'https'
      host.verify_mode = OpenSSL::SSL::VERIFY_NONE # Who cares!

      case response = host.get(uri.request_uri)
        when Net::HTTPSuccess     then uri
        when Net::HTTPRedirection then follow(uri['location'], limit - 1)
        else response.error!
      end
    end
  end
end
