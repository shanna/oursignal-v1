# vim: syntax=ruby
# encoding: utf-8
require ::File.join(::File.dirname(__FILE__), 'lib/oursignal')
require 'oursignal/web/server'

map('/'){ run Oursignal::Web::Server }
