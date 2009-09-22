require 'uri'
require 'addressable/uri'
require 'ext/string'

# TODO: Fix this mess up!
module URI
  module Sanatize
    def sanatize
      URI.sanatize(self)
    end
  end

  # TODO: Move this into Sanatize::ClassMethods and mixin.
  def self.sanatize(uri)
    sanatized = Addressable::URI.heuristic_parse(uri.to_s.to_utf8, {:scheme => 'http'}).normalize!

    case uri
      when URI::Generic, URI::HTTP then URI.parse(sanatized.to_s)
      when Addressable::URI        then sanatized
      else sanatized.to_s
    end
  end

  URI::Generic.send(:include, URI::Sanatize)
  URI::HTTP.send(:include, URI::Sanatize)
  Addressable::URI.send(:include, URI::Sanatize)
end
