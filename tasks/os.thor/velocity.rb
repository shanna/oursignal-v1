require File.join(File.dirname(__FILE__), 'common')

# TODO: Get more programatic and generate these tasks.
module Os
  class Velocity < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'update', %q{Velocity cache update.}
    def update
      run Oursignal::Velocity::Update
    end

    protected
      def run(klass)
        klass.run
      rescue File::Pid::PidFileExist
        true
      end
  end
end
