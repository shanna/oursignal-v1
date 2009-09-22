set :deploy_to, '/srv/staging.oursignal.com'
set :apache_config_extra, 'RackEnv staging'
set :apache_ip_restrictions, [
  '127.0.0.1',
  '203.206.182.106', # office
]
