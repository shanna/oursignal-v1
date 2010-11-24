# encoding: utf-8
root = File.join(File.dirname(__FILE__), '..')

# Bundler.
require File.join(root, 'gems', 'environment')
$:.unshift File.join(root, 'lib')

# Persistence.
require 'swift'
Swift.setup :default, Swift::DB::Postgres, db: 'oursignal'

module Oursignal
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def self.db
    Swift.db
  end
end # Oursignal

