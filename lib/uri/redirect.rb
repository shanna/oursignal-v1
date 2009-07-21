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
      self
    end

    # --
    # TODO: Check for circular redirects and throw a better error?
    def follow(url = self, limit = 10)
      raise 'Too many redirects' if limit == 0

      # Normalize the URI while we are here.
      uri = Addressable::URI.heuristic_parse(url.to_s, {:scheme => 'http'}).normalize!

      host             = Net::HTTP.new(uri.host, uri.port)
      host.use_ssl     = uri.scheme == 'https'
      host.verify_mode = OpenSSL::SSL::VERIFY_NONE # Who cares!

      request_uri = URI.parse(uri.to_s).request_uri rescue nil
      return uri unless request_uri

      case response = host.request_head(request_uri)
        when Net::HTTPSuccess
          uri
        when Net::HTTPRedirection
          redirect = Addressable::URI.heuristic_parse(response['location'], {:scheme => 'http'}).normalize!
          follow(uri.join(redirect), limit - 1)
        else
          response.error!
      end
    end
  end

  URI::Generic.send(:include, URI::Redirect)
  URI::HTTP.send(:include, URI::Redirect)
end
