role :web, 'www.oursignal.com'
role :app, 'www.oursignal.com'
role :db, 'www.oursignal.com', :primary => true
set :deploy_to, '/srv/www.oursignal.com'
