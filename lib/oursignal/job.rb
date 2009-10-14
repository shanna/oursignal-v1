require 'file/pid'

module Oursignal
  class Job
    def self.inherited(klass)
      klass.class_inheritable_accessor :subclasses
      klass.subclasses = []
      klass.superclass.subclasses << klass if klass.superclass.respond_to?(:subclasses)
    end

    def self.run
      pid_file = File.join(Oursignal.root, 'log', "#{Extlib::Inflection.underscore(to_s)}.pid")
      File::Pid.new(pid_file, Process.pid).run do
        new.call
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
  end
end

