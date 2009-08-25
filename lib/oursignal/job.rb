require 'file/pid'

module Oursignal
  class Job
    def self.run
      pid_file = File.join(Oursignal.root, 'log', "#{Extlib::Inflection.underscore(to_s)}.pid")
      File::Pid.new(pid_file, Process.pid).run do
        new.call
      end
    end

    def call
      raise NotImplementedError
    end
  end
end
