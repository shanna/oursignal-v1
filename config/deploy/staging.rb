set :deploy_to, '/srv/staging.oursignal.com'
set :apache_config_extra do
  %Q{
    RackEnv staging

    <Location />
      AuthName "Oursignal2 Private Beta"
      AuthType Basic
      AuthBasicProvider file
      AuthUserFile #{current_path}/config/htpasswd
      Require valid-user
    </Location>

    <Location /static/monit>
      Allow from all
      Satisfy any
    </Location>
  }
end
