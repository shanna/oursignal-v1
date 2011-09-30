require 'resque'

#--
# TODO: Logging.
module Resque
  module Workers
    def self.start options = {}
      raise "Already running #{Resque.workers.size} workers." if running?
      options.fetch(:workers, 1).to_i.times do |i|
        Process.fork do
          Process.daemon
          Resque::Worker.new(*options.fetch(:queues, %w{*})).work
        end
      end
    end

    def self.running?
      !Resque.workers.empty?
    end

    def self.stop
      pids = Resque.workers.map(&:pid)
      Process.kill('QUIT', *pids) unless pids.empty?
    end
  end # Workers
end # Resque

