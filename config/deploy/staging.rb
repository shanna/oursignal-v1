role :web, 'staging.oursignal.com'
role :app, 'staging.oursignal.com'
role :db, 'staging.oursignal.com', :primary => true
set :deploy_to, '/srv/staging.oursignal.com'
