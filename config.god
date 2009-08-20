# encoding: utf-8
# vim: syntax=ruby

require 'find'

merb_env = ENV['MERB_ENV'] || ENV['RACK_ENV'] || 'development'
root     = File.expand_path(File.dirname(__FILE__))
God.pid_file_directory = "#{root}/log"

God.watch do |w|
  w.name     = 'memcached'
  w.group    = 'os'
  w.interval = 30.seconds

  w.start         = "cd #{root} && memcached -d -m 64 -p 11211 -P #{root}/log/memcached.pid"
  w.start_grace   = 10.seconds
  w.stop          = "ps aux | awk '/memcached/ && !/awk/ {print $2}' | xargs -r kill"
  w.stop_grace    = 10.seconds
  w.restart       = w.stop + " && " + w.start
  w.restart_grace = 15.seconds

  w.pid_file = File.join(root, "log/memcached.pid")

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval  = 10.seconds
      c.running   = false
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state      = [:start, :restart]
      c.times         = 5
      c.within        = 5.minutes
      c.transition    = :unmonitored
      c.retry_in      = 10.minutes
      c.retry_times   = 5
      c.retry_within  = 2.hours
    end
  end
end

%w{feed score}.each do |server|
  God.watch do |w|
    path       = File.join(root, 'bin', server)
    w.group    = 'os'
    w.name     = server
    w.interval = 30.seconds

    w.start    = "cd #{root} && MERB_ENV=#{merb_env} /usr/bin/env thor os:#{server}:start"
    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 30.seconds
        c.running  = false
      end
    end
    w.behavior(:clean_pid_file)
  end
end

