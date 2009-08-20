require File.join(File.dirname(__FILE__), 'common')

module Os
  class Feed < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'start', %q{Start Oursignal feed process.}
    def start
      require 'oursignal/feed'
      Oursignal::Feed.run
    end
  end
end
