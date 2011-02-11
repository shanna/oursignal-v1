require File.join(File.dirname(__FILE__), '..', 'oursignal')
require 'resque'
require 'resque/plugins/lock'

# Jobs.
require 'oursignal/job/entry'
require 'oursignal/job/feed'
require 'oursignal/job/feed_get'
require 'oursignal/job/native_score_ycombinator'

module Oursignal
  module Job

    # Run job workers.
    #--
    # TODO: Env stuff to OO and Env handling to bin/ev-job.
    # TODO: Pid files for this stuff so monit can be happy?
    def self.start
      # Process.daemon do # Don't deamonize while we have no stop, log or pid.
        # TODO: Process.daemon. Master -> Slaves type deal. Master should watch the workers for that queue and restart
        # when required.
        queues = (ENV['QUEUES'] || ENV['QUEUE'] || '*').to_s.split(',')

        begin
          worker              = Resque::Worker.new(*queues)
          worker.verbose      = ENV['LOGGING'] || ENV['VERBOSE']
          worker.very_verbose = ENV['VVERBOSE']
        rescue Resque::NoQueueError
          abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
        end

        puts "Starting worker #{worker}"
        worker.log "Starting worker #{worker}"
        worker.work(ENV['INTERVAL'] || 5) # interval, will block
      # end
    end

    # Stop job workers.
    #--
    # TODO: Env stuff to OO and Env handling to bin/ev-job.
    # TODO: Find the master, have it send QUIT to all it's workers.
    def self.stop
      raise NotImplementedError
    end
  end # Job
end # Oursignal
