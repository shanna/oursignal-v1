require 'file/pid'

module Oursignal
  class Job
    def self.run
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

    def self.name
      self.to_s.downcase.gsub(/[^:]+::/, '')
    end

    def name
      self.class.name
    end

    def call
      raise NotImplementedError
    end
  end
end

