require 'postrank-uri'
require 'rack/utils'

module URI
  module Sanitize
    def self.parse original_uri
      uri       = PostRank::URI.clean(original_uri.to_s, raw: true)
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

