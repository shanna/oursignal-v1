require File.join(File.dirname(__FILE__), '..', 'oursignal')

module Oursignal
  module Cli
    def self.bin
      File.basename($0).gsub(/-/, ' ')
    end

    def self.root
      Oursignal.root
    end
  end # Cli
end # Oursignal
