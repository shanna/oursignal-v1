# vim: syntax=ruby
# encoding: utf-8
require File.join(File.dirname(__FILE__), 'lib/oursignal/web')

map('/'){ run Oursignal::Web }
