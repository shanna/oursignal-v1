require File.join(File.dirname(__FILE__), '..', 'oursignal')
require 'file/pid'
require 'logger'
require 'resque'
require 'resque/plugins/lock'

# Jobs.
require 'oursignal/job/entry'
require 'oursignal/job/feed'
require 'oursignal/job/score_native'

# Master.
# TODO: This is a bit backwards.
require 'oursignal/job/master'

Resque.after_fork{ Swift.db.reconnect}

module Oursignal
  #--
  # TODO: Submit all this worker running as a bin/lib patch for resque?
  module Job
    @pidfile = File.join(Oursignal.root, 'run', 'oursignal-job.pid')
    @logger  = Logger.new($stdout)

    class << self
      attr_reader :logger, :pidfile

      # Run job workers.
      #--
      def start daemonize = false, logfile = $stdout, n = 1

        @logger = Logger.new(logfile)
        if daemonize
          pid = Process.fork do
            Process.detach(Process.pid)
            Master.new(pidfile, logfile)
          end

          # if we want more workers, wait a bit and fire the TTIN signals.
          sleep(2) && (n - 1).times { sleep(0.5); Process.kill('TTIN', pid) } if n > 1
        else
          Master.new(pidfile, logfile)
        end
      end

      def stop
        pids = Resque.workers.map {|worker| worker.worker_pids}.flatten.map(&:to_i)
        Process.kill('QUIT', *pids) unless pids.empty?
      end

      # https://github.com/defunkt/resque/issues/180
      def cull n
        raise "Invalid secs #{n}, must be >= 600" if n < 600
        Resque.workers.select(&:working?).each do |worker|
          job     = worker.job
          pid     = worker.worker_pids.last
          elapsed = Time.now - DateTime.parse(job['run_at']).to_time
          if elapsed > n
            Resque::Failure.create(
              worker:     worker,
              queue:      job['queue'],
              payload:    job['payload'],
              exception:  Exception.new("Timeout and cull due to elapsed #{elapsed} secs"),
            )
            logger.info "Killing worker #{pid} running #{job}"
            Process.kill('KILL', pid.to_i) rescue nil
          end
        end
      end

      def mopup interval = 900
        mopped = 0
        cutoff = Time.now - interval
        Resque::Failure.all(0, Resque::Failure.count).each_with_index do |failure, idx|
          klass  = failure['payload']['class']
          failed = DateTime.parse(failure['failed_at']).to_time

          next if failed >= cutoff
          if re = RETRIED[klass] and re.match(failure['error'])
            Resque.redis.lrem(:failed, 0, Yajl.dump(failure))
            mopped += 1
          end
        end

        Job.info "mopped up #{mopped} failures" if mopped > 0
      end

      def more n
        abort "Master not running ?" unless File.exists?(pidfile)
        pid = File.read(pidfile).to_i
        n   = 1 if n < 1
        n.times { Process.kill('TTIN', pid) }
      end

      def less n
        abort "Master not running ?" unless File.exists?(pidfile)
        pid = File.read(pidfile).to_i
        n   = 1 if n < 1
        n.times { Process.kill('TTOU', pid) }
      end

      def format_message obj
        obj.kind_of?(Exception) ? "#{obj.message} - #{obj.backtrace[0..4].join("\n")}" : obj.to_s
      end

      def info  message; logger.info  format_message(message) end
      def warn  message; logger.warn  format_message(message) end
      def error message; logger.error format_message(message) end
    end
  end # Job
end # Oursignal
