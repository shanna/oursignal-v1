require 'rack/utils'
require 'uri'

module URI
  module Sanitize
    def self.parse original_uri
      uri       = URI.parse(original_uri.to_s).normalize
      params    = Hash[*Rack::Utils.parse_query(uri.query).sort.flatten]
      uri.query = Rack::Utils.build_query(params) unless params.empty?
      uri
    end
  end

  # Parse and sanitize a URI.
  def self.sanitize uri
    URI::Sanitize.parse uri
  end
end # URI

