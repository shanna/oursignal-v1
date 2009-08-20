require 'schedule'

module Schedule
  class Job
    def self.inherited(klass)
      klass.class_inheritable_accessor :subclasses, :interval
      klass.interval   = 5
      klass.subclasses = []
      klass.superclass.subclasses << klass if klass.superclass.respond_to?(:subclasses)
    end

    def self.run
      Schedule.run.series(interval){ new.call}
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
  end # Job
end # Schedule

