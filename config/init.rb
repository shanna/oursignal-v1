# encoding: utf-8
# Stupid fucking people requiring the entire active_support when they don't even need the json bullshit in there.
# The monkey patching conflicts with the monkey patching in json.
Merb.disable :json

require 'config/dependencies.rb'

use_test :test_unit
use_orm :datamapper
use_template_engine :erb

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '87107539db8cfa483be5b146200d88adb071300e'  # required for cookie session store
  c[:session_id_key] = '_oursignal/_session_id' # cookie session id key, defaults to "_session_id"
end

Merb::BootLoader.before_app_loads do
  # Cache with Mongo.
  require 'dm'
  require 'uri/redirect'
  # URI::Redirect::Cache.moneta = Moneta::MongoDB.new(
  #   :db         => MongoMapper.database.name,
  #   :collection => 'uri_redirect'
  # )

  require 'ext/string'
  # require 'ext/mongo'
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end

Merb.add_mime_type :rss, nil, %w{text/xml}
