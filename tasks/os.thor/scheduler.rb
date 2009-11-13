require File.join(File.dirname(__FILE__), 'common')

# TODO: Get more programatic and generate these tasks.
module Os
  class Scheduler < Thor
    def self.new(*args)
      Oursignal.merb_env
      require 'oursignal/scheduler'
      super(*args)
    end

    desc 'start', %q{Start oursignal scheduler.}
    def start
      Oursignal::Scheduler.run
    end

    desc 'stop', %q{Stop oursignal scheduler.}
    def stop
      pid = File::Pid.new(File.join(Oursignal.root, 'log', 'oursignal', 'scheduler.pid'))
      if pid.running?
        pid.kill(15)
      else
        warn 'not running'
      end
    end
  end
end
