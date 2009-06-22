require 'rubygems'

gems_dir = ::File.expand_path(::File.join(::File.dirname(__FILE__), '..', 'gems'))
Gem.clear_paths
$BUNDLE = true
Gem.path.unshift(gems_dir)


require 'merb-core'
require 'test/unit'

gem 'thoughtbot-shoulda'
require 'shoulda'

Merb.start(
  :testing     => true,
  :adapter     => 'runner',
  :environment => (ENV['MERB_ENV'] || 'test')
)
Dir.chdir(File.join(File.dirname(__FILE__), '..'))

class Test::Unit::TestCase
end

class MerbTest < Test::Unit::TestCase
end
