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
dependency 'merb-helpers', merb_gems_version
dependency 'merb-exceptions', merb_gems_version
dependency 'merb-slices', merb_gems_version
dependency 'merb-auth-core', merb_gems_version
dependency 'merb-auth-more', merb_gems_version
dependency 'merb-param-protection', merb_gems_version
dependency 'merb-exceptions', merb_gems_version

dependency 'ruby-openid', '2.1.6', :require_as => 'openid'
dependency 'nokogiri', '1.2.3'
dependency 'hpricot', '0.8.1'

# github
dependency 'mongodb-mongo', '0.8', :require_as => 'mongo'
dependency 'mongodb-mongo_record', '0.3', :require_as => 'mongo_record'
dependency 'pauldix-feedzirra', '0.0.12', :require_as => 'feedzirra'
dependency 'jnunemaker-columbus', '0.1.2', :require_as => 'columbus'
