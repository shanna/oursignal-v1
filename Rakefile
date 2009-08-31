require File.join(File.dirname(__FILE__), 'lib', 'oursignal')
require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "oursignal"
    gem.summary = %Q{TODO}
    gem.email = "shane.hanna@gmail.com"
    gem.homepage = "http://github.com/shanna/oursignal"
    gem.authors = ["Shane Hanna"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  # No gemspec, I'm just using the version and release code from jeweler.
  class Jeweler::Commands::Release
    def regenerate_gemspec!; end
    def gemspec_changed?; false end
  end # Jeweler::Commands::Release
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

Oursignal.merb_env(:environment => ENV['MERB_ENV'] || 'rake', :adapter => 'runner')
require 'merb-core/tasks/merb'

# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r }

desc 'Start runner environment'
task :merb_env do
  Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake', :adapter => 'runner')
end

task :default => :test

