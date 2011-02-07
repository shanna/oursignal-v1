require 'uri/sanitize'

module URI
  module Domain

    # Common form of 'domain name', name + public suffix.
    #--
    # TODO: Implement this based on Mozilla's Public Suffix List.
    # http://publicsuffix.org/
    def self.parse original_uri
      uri = URI.sanitize(original_uri.to_s)

      # return nil unless found_tld = tld
      # /([^.]+\.#{Regexp.escape(found_tld.suffix)})/.match(host)[1]
      return nil if uri.host.nil? || uri.host.empty?
      re    = %r{^(?:(?>[a-z0-9-]*\.)+?|)([a-z0-9-]+\.(?>[a-z]*(?>\.[a-z]{2})?))$}i
      match = re.match(uri.host)
      match && match[1]
    end
  end

  def self.domain uri
    URI::Domain.parse uri
  end
end

