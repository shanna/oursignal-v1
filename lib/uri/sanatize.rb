require 'uri/redirect'

module URI
  module Sanatize
    def sanatize!
      final = sanatize
      self.host = final.host
      self.path = final.path
      self
    end

    def sanatize
      uri = URI.parse(Addressable::URI.heuristic_parse(to_s, {:scheme => 'http'}).normalize!)
      uri.follow
    end
  end

  def self.sanatize(uri)
    final = parse(uri).sanatize!
    uri.is_a?(String) ? final.to_s : final
  end

  URI::Generic.send(:include, URI::Sanatize)
  URI::HTTP.send(:include, URI::Redirect)
end
