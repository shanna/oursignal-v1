# bin/merb -V to get a better error messages.
merb_gems_version = '1.0.11'
dependency 'merb-core', merb_gems_version
dependency 'merb-assets', merb_gems_version
dependency('merb-cache', merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency 'merb-helpers', merb_gems_version
dependency 'merb-exceptions', merb_gems_version

do_gems_version = '0.9.12'
dm_gems_version = '0.9.11'
dependency 'data_objects', do_gems_version
dependency 'dm-core', dm_gems_version
dependency 'merb_datamapper', merb_gems_version

# Github

# Requires tokyocabinet.
# http://transact.dl.sourceforge.net/sourceforge/tokyocabinet/tokyocabinet-1.4.23.tar.gz
# http://transact.dl.sourceforge.net/sourceforge/tokyocabinet/tokyocabinet-ruby-1.25.tar.gz
# TODO: Dunno what it is but the ruby bindings have a lot of trouble finding the shared TC libs.
# I ended up symlinking /usr/lib/libtokyocabinet.so.8 to /usr/local/lib/tokyocabinet.so.8
dependency 'shanna-dm-tokyo-cabinet-adapter', '0.1.6', :require_as => 'dm-tokyo-cabinet-adapter'

# Thor/other libs.
dependency 'pauldix-feedzirra', '0.0.12', :require_as => nil
