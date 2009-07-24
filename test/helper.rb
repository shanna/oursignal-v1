require File.join(File.dirname(__FILE__), '..', 'lib', 'oursignal')
require 'test/unit'

Oursignal.merb_env(
  :testing     => true,
  :adapter     => 'runner',
  :environment => (ENV['MERB_ENV'] || 'test')
)

gem 'thoughtbot-shoulda'
require 'shoulda'

class Test::Unit::TestCase
end

class MerbTest < Test::Unit::TestCase
end
