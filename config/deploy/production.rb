set :deploy_to, '/srv/www.oursignal.com'
set :apache_server_name, 'oursignal.com'
set :apache_config_extra, <<END
  ServerAlias www.oursignal.com
  RewriteEngine On
  RewriteRule ^/.*\.php / [R]
END
