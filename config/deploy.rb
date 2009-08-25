set :application,      'oursignal'
set :repository,       'git@github.com:stateless-systems/oursignal.git'
set :scm,              :git
set :deploy_via,       :remote_cache
set :branch,           'master'
set :repository_cache, 'git_cache'
set :user,             'root'
set :use_sudo,          false
set :passenger_user,   'nobody'
set :passenger_group,  'nogroup'

set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
set(:merb_env){ stage }

namespace :deploy do
  desc 'Restarts passenger'
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc 'Recreate crontab'
  task :crontab do
    run "cd #{release_path} && MERB_ENV=#{stage} bin/thor os:crontab:redeploy"
  end

  desc 'Recreate gems'
  task :gems do
    run "cd #{release_path} && MERB_ENV=#{stage} bin/thor merb:gem:redeploy"
  end

  desc 'Sets permissions'
  task :permissions, :roles => :web do
    # Ruby inline complains if you make your directory group writable but apache must be able to write here.
    run "chown #{passenger_user} #{release_path}/tmp"
    run "chmod g-w #{release_path}/tmp"

    # Merb page caches.
    run "chown #{passenger_user} #{release_path}/public"

    # Merb bundling.
    run "chown #{passenger_user} #{release_path}/public/stylesheets"
    run "chown #{passenger_user} #{release_path}/public/javascripts"
  end

  desc 'Automigrates the database destructively'
  task :automigrate, :roles => :db do
    run "cd #{current_path} && MERB_ENV=#{stage} bin/rake db:automigrate"
  end

  desc 'Autoupgrading the database non-destructively'
  task :autoupgrade, :roles => :db do
    run "cd #{current_path} && MERB_ENV=#{stage} bin/rake db:autoupgrade"
  end

  desc 'Migrates the database using migrations'
  task :migrate, :roles => :db do
    run "cd #{current_path} && MERB_ENV=#{stage} bin/rake db:migrate"
  end
end

after 'deploy:cold'.to_sym,        'deploy:automigrate'
after 'deploy:update_code'.to_sym, 'deploy:gems'
after 'deploy:update_code'.to_sym, 'deploy:permissions'
after 'deploy:restart'.to_sym,     'deploy:crontab'
