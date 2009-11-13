require 'file/pid'

module Oursignal
  class Job
    def self.run(forking = true)

      if forking
        pid = fork do
          Daemons.daemonize
          Process.setpriority(Process::PRIO_PROCESS, 0, 10)
          _run
        end
        Process.detach(pid)
        print "%s os:job(%d)\t%s\n" % [DateTime.now.to_s, pid, to_s.downcase.gsub(/::/, ':')]
      else
        print "%s os:job\t%s\n" % [DateTime.now.to_s, to_s.downcase.gsub(/::/, ':')]
        _run
      end
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
        pid_file = File.join(Oursignal.root, 'log', "#{Extlib::Inflection.underscore(to_s)}.pid")
        pid      = File::Pid.new(pid_file, Process.pid)
        pid.run do
          $0 = 'os:job - ' + to_s.downcase.gsub(/::/, ':')
          new.call
        end
      rescue File::Pid::PidFileExist
      ensure
        pid
      end
  end
end

