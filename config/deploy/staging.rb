role :web, 'staging.oursignal.com'
role :app, 'staging.oursignal.com'
role :db, 'staging.oursignal.com', :primary => true
set :deploy_to, '/srv/staging.oursignal.com'

set :apache_config_extra, <<__CONFIG__
  RackEnv staging

  <Directory #{deploy_to}>
    Order deny,allow
    Deny from all
    Allow from 127.0.0.1
    Allow from 203.206.182.106 # office
  </Directory>
__CONFIG__
