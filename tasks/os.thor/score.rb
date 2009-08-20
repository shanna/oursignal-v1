require File.join(File.dirname(__FILE__), 'common')

module Os
  class Score < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'start', %q{Start Oursignal score process.}
    def start
      require 'oursignal/score'
      Oursignal::Score.run
    end
  end
end
