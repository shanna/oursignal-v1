require File.join(File.dirname(__FILE__), '..', 'lib', 'oursignal')
require 'test/unit'

Oursignal.merb_env(
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
