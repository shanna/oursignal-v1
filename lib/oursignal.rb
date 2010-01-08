module Oursignal
  def self.merb_env(options = {})
    require File.join(root, 'gems', 'environment')

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
