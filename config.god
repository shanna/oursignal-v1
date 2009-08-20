# encoding: utf-8
# vim: syntax=ruby

require 'find'

merb_env = ENV['MERB_ENV'] || ENV['RACK_ENV'] || 'development'
root     = File.expand_path(File.dirname(__FILE__))
God.pid_file_directory = "#{root}/log"

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

