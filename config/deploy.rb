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

role :web, '72.47.219.75'
role :app, '72.47.219.75'
role :db, '72.47.219.75', :primary => true

set :deploy_to, '/srv/www.oursignal.com'
set :apache_server_name, 'oursignal.com'
set :apache_config_extra, <<END
  ServerAlias www.oursignal.com
  RewriteEngine On
  RewriteRule ^/.*\.php / [R]
END

set :application, 'oursignal'
set :repository,  'git@github.com:stateless-systems/oursignal.git'

# Jeweler is required on the system level because Rakefile loads it before the
# gem paths are tweaked by Merb
set :gems, fetch(:gems, []).push('jeweler')

# Change the apache port because we run a caching service (varnish) on port 80
set :apache_port, '8080'

set(:default_environment) do
  {'MERB_ENV' => 'production'}
end

set :apache_monit_test_urls, ['http://www.oursignal.com:8080/static/monit']
set :varnish_monit_test_urls, ['http://www.oursignal.com/static/monit']
set :monit_cpu_user, '80% for 2 cycles'
set :monit_memory_usage, '90%'
set :monit_cpu_wait, '50% for 2 cycles'
set :monit_load_1min, '10'
set :monit_load_5min, '5'

# Use bundler instead of thor for gems
set :'use_bundler?', true

# We don't have any migrations yet
set :'merb_use_automigrate?', false
set :'merb_use_autoupgrade?', false
set :'use_migrations?', false

namespace :deploy do
  desc 'Score tasks'
  task :scores do
    run "cd #{current_path}/src && make"
    run "cd #{current_path}/src && make install"
  end

  namespace :scheduler do
    desc 'Stop scheduler'
    task :stop do
      run "#{thor} os:scheduler:stop"
    end

    desc 'Start scheduler'
    task :start do
      run "#{thor} os:scheduler:start"
    end
  end
end

before 'deploy', 'deploy:scheduler:stop'
after  'deploy', 'deploy:scores'
after  'deploy', 'deploy:scheduler:start'

