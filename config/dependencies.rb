merb_gems_version = '1.1'

# bin/merb -V to get a better error messages.
dependency 'merb-core', merb_gems_version
dependency 'merb-assets', merb_gems_version
dependency('merb-cache', merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency 'merb-actionorm', merb_gems_version # only required for helpers :(
dependency 'merb-mailer', merb_gems_version
dependency 'merb-helpers', merb_gems_version
dependency 'merb-exceptions', merb_gems_version
dependency 'merb-slices', merb_gems_version
dependency 'merb-auth-core', merb_gems_version
dependency 'merb-auth-more', merb_gems_version
dependency 'merb-param-protection', merb_gems_version

do_gems_version = '0.10.0'
dm_gems_version = '0.10.0'
dependency 'data_objects', do_gems_version
dependency 'do_mysql', do_gems_version
dependency 'dm-core', dm_gems_version
dependency 'dm-constraints', dm_gems_version
dependency 'dm-migrations', dm_gems_version
dependency 'dm-serializer', dm_gems_version
dependency 'dm-timestamps', dm_gems_version
dependency 'dm-types', dm_gems_version
dependency 'dm-validations', dm_gems_version

dependency 'merb_datamapper', merb_gems_version

dependency 'eventmachine', '0.12.8'
dependency 'mailfactory', '1.4.0'
dependency 'moneta', '0.6.0'
# dependency 'addressable', '2.1.0', :require_as => 'addressable/uri'
dependency 'hpricot', '0.8.1'
dependency 'nokogiri', '1.2.3'
dependency 'ruby-openid', '2.1.6', :require_as => 'openid'

# github
dependency 'taf2-curb', '0.4.8.0', :require_as => 'curb'
dependency 'thoughtbot-shoulda', '2.10.1', :require_as => 'shoulda'
dependency 'jnunemaker-columbus', '0.1.2', :require_as => 'columbus'
dependency 'pauldix-feedzirra', '0.0.15', :require_as => 'feedzirra'
