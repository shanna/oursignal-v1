# coding: utf-8
# vim: syntax=ruby

# This file provides support for Phusion Passenger
# More info: http://wiki.merbivore.com/deployment/passenger

if ::File.join(::File.dirname(__FILE__), 'bin', 'common.rb'))
  require ::File.join(::File.dirname(__FILE__), 'bin', 'common')
end
require 'merb-core'

Merb::Config.setup(
  :merb_root   => ::File.expand_path(::File.dirname(__FILE__)),
  :environment => ENV['RACK_ENV']
)
Merb.environment = Merb::Config[:environment]
Merb.root        = Merb::Config[:merb_root]
Merb::BootLoader.run

run Merb::Rack::Application.new

