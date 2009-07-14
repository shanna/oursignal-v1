require 'eventmachine'

module Oursignal
  # Like a cron-job except it wont overlap/poll when it's already working on something. You can also group them
  # together into a single multi-threaded daemon by subclass.
  class Job
    include EM::Deferrable

    def self.inherited(klass)
      klass.class_inheritable_accessor :subclasses, :poll_time
      klass.poll_time  = 5
      klass.subclasses = []
      klass.superclass.subclasses << klass if klass.superclass.respond_to?(:subclasses)
    end

    def self.run
      job = new
      job.callback{ EM.add_timer(poll_time, method(:run))}
      Thread.new do
        begin
          res = job.poll
          job.work(res) if res && !res.nil? && (res.respond_to?(:empty?) ? !res.empty? : true)
        ensure
          job.succeed
        end
      end
    end

    def self.name
      self.to_s.downcase.gsub(/[^:]+::/, '')
    end

    def name
      self.class.name
    end

    def poll
      raise NotImplementedError
    end

    def work(res = nil)
      raise NotImplementedError
    end
  end # Job
end # Oursignal
