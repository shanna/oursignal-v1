# vim: syntax=ruby
# disable_system_gems
source "http://gemcutter.org"
bundle_path 'gems'

gem 'merb-pre'

merb_gems_version = '1.1.0.pre'
gem 'merb-core', merb_gems_version
gem 'merb-assets', merb_gems_version
# gem 'merb-actionorm', merb_gems_version # only required for helpers :(
gem 'merb-mailer', merb_gems_version
gem 'merb-helpers', merb_gems_version
gem 'merb-exceptions', merb_gems_version
gem 'merb-slices', merb_gems_version
gem 'merb-auth-core', merb_gems_version
gem 'merb-auth-more', merb_gems_version
gem 'merb-param-protection', merb_gems_version
gem 'merb-builder'

do_gems_version = '0.10.0'
dm_gems_version = '0.10.1'
gem 'data_objects', do_gems_version
gem 'do_mysql', do_gems_version
gem 'dm-core', dm_gems_version
gem 'dm-aggregates', dm_gems_version
gem 'dm-constraints', dm_gems_version
gem 'dm-migrations', dm_gems_version
gem 'dm-serializer', dm_gems_version
gem 'dm-timestamps', dm_gems_version
gem 'dm-types', dm_gems_version
gem 'dm-validations', dm_gems_version

gem 'merb_datamapper', merb_gems_version

gem 'json'
gem 'addressable', '>= 2.1.0', :require_as => 'addressable/uri'
gem 'curb'
gem 'feedzirra', '>= 0.0.20'
gem 'klarlack'
gem 'mailfactory', '1.4.0'
gem 'memcache-client', '1.7.4', :require_as => 'memcache'
gem 'moneta'
gem 'nokogiri'

# 1.8 only
gem 'system_timer', '1.0'

# Gah Dan. Rule number one of gems should be the gem name matches the require.
gem 'uri-meta', '0.9.4', :require_as => 'uri/meta'

# These are for deployment only, they will be required when needed

only :test do
  gem 'shoulda'
end

only :tasks do
  gem 'rufus-scheduler'
  gem 'eventmachine'
  gem 'daemons'
end

only :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'stateless-systems-capistrano-ext', '0.12.3'
end
