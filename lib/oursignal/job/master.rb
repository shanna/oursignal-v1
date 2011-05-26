require 'resque'

module Oursignal
  module Job
    class Master
      attr_reader :logger, :workers

      def initialize pidfile, logfile
        @logger  = Logger.new(logfile, 0)
        @workers = []

        File::Pid.new(pidfile, Process.pid).run do
          Signal.trap('ABRT') { stop_all  }
          Signal.trap('TTIN') { start_one }
          Signal.trap('TTOU') { stop_one  }
          start_one

          Process.waitall
          logger.info "Stopped all workers"
        end
      end

      def start_one
        pid = fork { run }
        workers << pid
        logger.info  "Started one more worker #{pid}"
        $stdout.puts "Started one more worker #{pid}"
      end

      def stop_one
        return if workers.empty?
        pid = workers.pop
        logger.info  "Stopping one worker #{pid}"
        $stdout.puts "Stopping one worker #{pid}"
        Process.kill('TERM', pid)
      end

      def stop_all
        return if workers.empty?
        logger.info "Stopping all workers"
        Process.kill('TERM', *workers)

        logger.info  "Stopping master"
        $stdout.puts "Stopping master"
        Process.kill('TERM', Process.pid)

        # nuke any remaining locks.
        redis = Redis.connect
        redis.del(*redis.keys("resque:lock:*")) rescue true
      end

      def run
        queues = (ENV['QUEUES'] || ENV['QUEUE'] || '*').to_s.split(',')

        begin
          worker              = Resque::Worker.new(*queues)
          worker.verbose      = ENV['LOGGING'] || ENV['VERBOSE']
          worker.very_verbose = ENV['VVERBOSE']
        rescue Resque::NoQueueError
          logger.error "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
          abort
        end

        logger.info "Starting worker #{worker}"
        worker.log  "Starting worker #{worker}"

        # interval, will block
        worker.work ENV['INTERVAL'] || 5
        exit
      end
    end # Master
  end # Job
end # Oursignal
