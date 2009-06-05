# coding: utf-8
# vim: syntax=ruby

# This file provides support for Phusion Passenger
# More info: http://wiki.merbivore.com/deployment/passenger

require 'rubygems'

gems_dir = File.expand_path(File.join(File.dirname(__FILE__), 'gems'))
Gem.clear_paths
$BUNDLE = true
Gem.path.unshift(gems_dir)

require 'merb-core'

Merb::Config.setup(
  :merb_root   => ::File.expand_path(::File.dirname(__FILE__)),
  :environment => ENV['RACK_ENV']
)
Merb.environment = Merb::Config[:environment]
Merb.root        = Merb::Config[:merb_root]
Merb::BootLoader.run

run Merb::Rack::Application.new

