require File.join(File.dirname(__FILE__), '..', 'lib', 'oursignal')
require 'test/unit'

require 'rubygems'
if (local_gem_dir = File.join(Oursignal.root, 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

Dir.chdir(::Oursignal.root)
require 'merb-core'

Merb.start_environment(
  :testing     => true,
  :adapter     => 'runner',
  :environment => (ENV['MERB_ENV'] || 'test')
)

db = File.expand_path(File.join(File.dirname(__FILE__), '..', 'schema', 'oursignal.sql'))
`mysqldump --no-data oursignal > #{db}`

class Test::Unit::TestCase
  def default_test; end
end

class MerbTest < Test::Unit::TestCase
  def setup
    db    = File.expand_path(File.join(File.dirname(__FILE__), '..', 'schema', 'oursignal.sql'))
    mysql = `mysql oursignal_test < #{db} 2>&1`
    raise %{Re-create database failed:\n #{mysql}} unless mysql.blank?
  end
end
