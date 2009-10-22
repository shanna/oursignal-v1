require File.join(File.dirname(__FILE__), 'common')

# TODO: Get more programatic and generate these tasks.
module Os
  class Velocity < Thor
    def self.new(*args)
      Oursignal.merb_env
      require 'oursignal/velocity'
      super(*args)
    end

    desc 'update', %q{Velocity cache update.}
    def update
      run Oursignal::Velocity::Update
    end

    desc 'expire', %q{Velocity cache expire.}
    def expire
      run Oursignal::Velocity::Expire
    end

    protected
      def run(klass)
        klass.run
      rescue File::Pid::PidFileExist
        true
      end
  end
end
