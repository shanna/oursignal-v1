# Schema.
require 'oursignal/scheme/link'

module Oursignal
  class Link < Scheme::Link
    def self.find id
      execute(%q{select * from links where id = ? or url = ?}, id.to_s.to_i, id).first
    end
  end # Link
end # Oursignal
