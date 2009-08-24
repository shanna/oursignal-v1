require 'rufus/scheduler'
require 'eventmachine'

module Schedule
  def self.run(options = {}, &block)
    if block_given?
      EM.run do
        Signal.trap('TERM'){ stop}
        Signal.trap('INT'){ stop}
        Signal.trap('QUIT'){ stop}
        sc = run(options)
        block.call(sc)
      end
    else
      Thread.main[:_schedule_rufus_scheduler] ||= Rufus::Scheduler.start_new(options)
    end
  end

  def self.stop
    run do |sc|
      # Unschedule everything and wait for threads.
      # jobs = sc.jobs.map{|jid, job| job}
      # jobs.each(&:unschedule)
      # TODO: loop while jobs.select{|job| job.thread.alive?}
      EM.stop
    end
  end

  class Series < Rufus::Scheduler::EveryJob
    def trigger
      super
      unschedule

      # Locking.
      @scheduler.in 1 do |job|
        if @job_thread && @job_thread.alive?
          @scheduler.in(1, nil, {:tags => [tags, 'lock'].flatten}, &job.block)
        else
          schedule_next
        end
      end
    end
  end # SeriesJob

  # I hate having to monkey patch stuff.
  module SeriesHelper
    def series(t, s = nil, opts = {}, &block)
      add_job(Schedule::Series.new(self, t, combine_opts(s, opts), &block))
    end
  end
  Rufus::Scheduler::SchedulerCore.send(:include, SeriesHelper)
end # Schedule

