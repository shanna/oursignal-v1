# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

module Oursignal
  def self.merb_env
    require 'rubygems'
    require 'merb-core'
    ::Merb.start(:environment => (ENV['MERB_ENV'] || 'development'))
    Dir.chdir(File.join(File.dirname(__FILE__), '..', '..'))
  end
end # Oursignal

