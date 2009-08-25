require File.join(File.dirname(__FILE__), 'common')

# TODO: Get more programatic and generate these tasks.
module Os
  class Feed < Thor
    def self.new(*args)
      Oursignal.merb_env
      require 'oursignal/feed'
      super(*args)
    end

    desc 'expire', %q{Feed expire.}
    def expire
      run Oursignal::Feed::Expire
    end

    desc 'update', %q{Feed update.}
    def update
      run Oursignal::Feed::Update
    end

    protected
      def run(klass)
        klass.run
      rescue File::Pid::PidFileExist
        true
      end
  end
end
