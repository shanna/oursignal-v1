# encoding: utf-8
root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join(root, 'lib')

Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'

# Fucking Bundler.
Dir.chdir(root) do
  require 'bundler'
  Bundler.setup :default
end

# Persistence.
require 'swift'
Swift.setup :default, Swift::DB::Postgres, db: 'oursignal'

# Logging.
require 'logger'

module Oursignal
  VERSION    = '0.3.0'
  # USER_AGENT = "oursignal/#{VERSION} +oursignal.com"
  # Fake some Chrome.
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.168 Safari/535.19'

  class << self
    def root
      File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end

    def db *args, &block
      Swift.db *args, &block
    end

    def log
      Logger.new(STDERR)
    end
  end
end # Oursignal

