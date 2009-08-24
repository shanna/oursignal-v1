module Oursignal
  def self.merb_env(options = {})
    require 'rubygems'
    if (local_gem_dir = File.join(root, 'gems')) && $BUNDLE.nil?
      $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
    end

    Dir.chdir(root)
    require 'merb-core'
    # The old way. Forking caused issues.
    # ::Merb.start_environment({:environment => (ENV['MERB_ENV'] || 'development')}.update(options))
    ::Merb.load_dependencies
    ::Merb::Orms::DataMapper::Connect.run
    ::Merb::BootLoader::LoadClasses.load_classes(File.join(root, 'app', 'models', '*'))
  end

  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end
