# Go to http://wiki.merbivore.com/pages/init-rb

require 'config/dependencies.rb'

use_test :test_unit
use_template_engine :erb

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '87107539db8cfa483be5b146200d88adb071300e'  # required for cookie session store
  c[:session_id_key] = '_oursignal/_session_id' # cookie session id key, defaults to "_session_id"
end

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end
