require 'file/pid'

module Oursignal
  class Job
    def self.run
      pid = Process.fork do 
        app = to_s.downcase.gsub(/::/, ':')
        log = File.join(Oursignal.root, 'log', "#{Extlib::Inflection.underscore(to_s)}.log")
        Daemonize.daemonize(log, app)
        Process.setpriority(Process::PRIO_PROCESS, 0, 10)
        begin
          print "%s(%d)\t%s\n" % [DateTime.now.to_s, Process.pid, to_s.downcase.gsub(/::/, ':')]
          pid_file = File.join(Oursignal.root, 'log', "#{Extlib::Inflection.underscore(to_s)}.pid")
          pid      = File::Pid.new(pid_file, Process.pid)
          pid.run{ new.call}
        rescue File::Pid::PidFileExist
        ensure
          pid
        end
      end
      Process.detach(pid)
    end

    def self.name
      self.to_s.downcase.gsub(/[^:]+::/, '')
    end

    def name
      self.class.name
    end

    def call
      raise NotImplementedError
    end

    private
      def self._run
        print "%s(%d)\t%s\n" % [DateTime.now.to_s, Process.pid, to_s.downcase.gsub(/::/, ':')]
        pid_file = File.join(Oursignal.root, 'log', "#{Extlib::Inflection.underscore(to_s)}.pid")
        pid      = File::Pid.new(pid_file, Process.pid)
        pid.run{ new.call}
      rescue File::Pid::PidFileExist
      ensure
        pid
      end
  end
end

