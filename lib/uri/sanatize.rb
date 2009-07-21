require 'uri/redirect'

module URI
  module Sanatize
    def sanatize!(follow = true)
      final = sanatize(follow)
      self.host = final.host
      self.path = final.path
      self
    end

    def sanatize(follow = true)
      uri = URI.parse(Addressable::URI.heuristic_parse(to_s, {:scheme => 'http'}).normalize!)
      follow ? uri.follow : uri
    end
  end

  def self.sanatize(uri, follow = true)
    final = parse(uri).sanatize!
    uri.is_a?(String) ? final.to_s : final
  end

  URI::Generic.send(:include, URI::Sanatize)
  URI::HTTP.send(:include, URI::Redirect)
end
