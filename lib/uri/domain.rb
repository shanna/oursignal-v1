require 'tld'

module URI
  module Domain

    # Common form of 'domain name', name + public suffix.
    #--
    # TODO: Implement this based on Mozilla's Public Suffix List.
    # http://publicsuffix.org/
    def domain
      # return nil unless found_tld = tld
      # /([^.]+\.#{Regexp.escape(found_tld.suffix)})/.match(host)[1]
      return nil if host.nil? || host.empty?
      re    = %r{^(?:(?>[a-z0-9-]*\.)+?|)([a-z0-9-]+\.(?>[a-z]*(?>\.[a-z]{2})?))$}i
      match = re.match(host)
      match && match[1]
    end
  end

  URI::Generic.send(:include, URI::Domain)
  URI::HTTP.send(:include, URI::Domain)
  Addressable::URI.send(:include, URI::Domain)
end

