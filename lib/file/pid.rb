require 'etc'
require 'fileutils'

# Pid file handling stolen mostly from Thin.
class File
  class Pid
    class PidFileExist < StandardError; end

    def initialize(file, pid = nil)
      @file = file

      return unless pid
      remove_stale_pid
      FileUtils.mkdir_p File.dirname(@file)
      open(@file, 'w'){|f| f.write(pid)}
      File.chmod(0644, @file)
    end

    def run(&block)
      block.call
    ensure
      delete
    end

    def pid
      open(@file, 'r').read.to_i if @file && File.exists?(@file)
    end

    def delete
      File.delete(@file) if @file && File.exists?(@file)
    end

    def running?
      pid && Process.getpgid(pid) != 1
    rescue Errno::ESRCH
      false
    end

    def kill!
      Process.kill('KILL', pid)
      delete
    end

    def kill(signal, timeout = 60)
      pid && Process.kill(signal, pid)
      Timeout.timeout(timeout) do
        sleep 0.1 while running?
      end
    rescue Timeout::Error
      kill!
    rescue Interrupt
      kill!
    rescue Errno::ESRCH # No such process
      kill!
    end

    protected
      def remove_stale_pid
        if File.exist?(@file)
          if pid && running?
            raise PidFileExist, "#{@file} already exists, seems like it's already running (process ID: #{pid})."
          else
            delete
          end
        end
      end
  end # Pid
end # File
