merb_gems_version = '1.0.11'
do_gems_version   = '0.9.13'
dm_gems_version   = '0.10.0'

# bin/merb -V to get a better error messages.
dependency 'merb-core', merb_gems_version
dependency 'merb-assets', merb_gems_version
dependency('merb-cache', merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency 'merb-helpers', merb_gems_version
dependency 'merb-exceptions', merb_gems_version

dependency 'data_objects', do_gems_version
dependency 'dm-core', dm_gems_version
dependency 'dm-validations', dm_gems_version

dependency 'ruby-openid', '2.1.6', :require_as => 'openid'

# Github

# http://transact.dl.sourceforge.net/sourceforge/tokyocabinet/tokyocabinet-1.4.23.tar.gz
dependency 'shanna-dm-tokyo-adapter', '0.2.1', :require_as => 'dm-tokyo-adapter' do
  # TODO: Replace with merb_datamapper once Merb 1.1 and DM 0.10.0 is released.
  DataMapper.setup(:default,
    :adapter  => 'tokyo_cabinet',
    :database => 'tc',
    :path     => Merb.root
  )
end

# Thor/other libs.
# TODO: :require_as => nil once I move all this code out of the Feed model.
dependency 'nokogiri', '1.2.3'
dependency 'pauldix-feedzirra', '0.0.12', :require_as => 'feedzirra'
dependency 'jnunemaker-columbus', '0.1.2', :require_as => 'columbus'
