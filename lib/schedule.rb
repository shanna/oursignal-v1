require 'rufus/scheduler'
require 'eventmachine'

module Schedule
  def self.run(&block)
    if block_given?
      EM.run do
        # TODO: Trap INT, QUIT, KILL etc.
        # - unschedule everything
        # - wait for everything already running to stop
        # - EM.stop
        sc = run
        block.call(sc)
      end
    else
      # I think I have this right. Should allow for schedulers in different processes.
      Thread.current[:_schedule_rufus_scheduler] ||= Rufus::Scheduler.start_new
    end
  end

  class Series < Rufus::Scheduler::EveryJob
    def trigger
      super
      unschedule

      # Locking.
      @scheduler.in 1 do |job|
        if @job_thread && @job_thread.alive?
          @scheduler.in 1, &job.block
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

