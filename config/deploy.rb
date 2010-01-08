require 'capistrano/ext/common'
require 'capistrano/ext/centos'
require 'capistrano/ext/git'
require 'capistrano/ext/apache'
require 'capistrano/ext/passenger'
require 'capistrano/ext/merb'
require 'capistrano/ext/curb'
require 'capistrano/ext/nokogiri'
require 'capistrano/ext/mysql'
require 'capistrano/ext/basic-authentication'
require 'capistrano/ext/memcached'
require 'capistrano/ext/monit'
require 'capistrano/ext/varnish'
require 'capistrano/ext/multistage'

role :web, '72.47.219.75'
role :app, '72.47.219.75'
role :db, '72.47.219.75', :primary => true

set :application, 'oursignal'
set :repository,  'git@github.com:stateless-systems/oursignal.git'

# Jeweler is required on the system level because Rakefile loads it before the
# gem paths are tweaked by Merb
set :gems, fetch(:gems, []).push('jeweler')

# Change the apache port because we run a caching service (varnish) on port 80
set :apache_port, '8080'

set :apache_monit_test_urls, ['http://www.oursignal.com:8080/static/monit']
set :varnish_monit_test_urls, ['http://www.oursignal.com/static/monit']
set :monit_cpu_user, '80% for 2 cycles'
set :monit_memory_usage, '90%'

# Use bundler instead of thor for gems
set :'use_bundler?', true

# We don't have any migrations yet
set :'merb_use_automigrate?', false
set :'merb_use_autoupgrade?', false
set :'use_migrations?', false

set(:default_environment) do
  { 'MERB_ENV' => stage }
end

namespace :deploy do
  desc 'Score tasks'
  task :scores do
    run "cd #{current_path}/src && make"
    run "cd #{current_path}/src && make install"
  end

  desc 'Restart scheduler'
  task :scheduler do
    run "#{thor} os:scheduler:stop"
    run "#{thor} os:scheduler:start"
  end
end

after 'deploy:restart', 'deploy:scores'
after 'deploy:restart', 'deploy:scheduler'
after 'deploy:start', 'deploy:scores'
after 'deploy:start', 'deploy:scheduler'
