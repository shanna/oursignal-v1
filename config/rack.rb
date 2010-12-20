# vim: syntax=ruby
# encoding: utf-8
require ::File.join(::File.dirname(__FILE__), 'lib/oursignal')
require 'oursignal/web'
require 'oursignal/web/users'
require 'resque/server'

map('/')            { run Oursignal::Web        }
map('/users')       { run Oursignal::Web::Users }
map('/admin/resque'){ run Resque::Server        }
