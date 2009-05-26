merb_gems_version = "1.1"
dependency "merb-core", merb_gems_version 
dependency "merb-assets", merb_gems_version
dependency("merb-cache", merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency "merb-helpers", merb_gems_version
# dependency "merb-slices", merb_gems_version
# dependency "merb-auth-core", merb_gems_version
# dependency "merb-auth-more", merb_gems_version
# dependency "merb-exceptions", merb_gems_version
# dependency "merb-gen", merb_gems_version

do_gems_version = "0.9.12"
dependency "data_objects", do_gems_version

dm_gems_version = "0.9.11"
dependency "dm-core", dm_gems_version

dependency "merb_datamapper", merb_gems_version

# Github
dependency 'shanna-dm-tokyo-cabinet-adapter', '0.1.6', :require_as => 'dm-tokyo-cabinet-adapter'
