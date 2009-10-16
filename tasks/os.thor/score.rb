require File.join(File.dirname(__FILE__), 'common')

# TODO: Get more programatic and generate these tasks.
module Os
  class Score < Thor
    def self.new(*args)
      Oursignal.merb_env
      require 'oursignal/score'
      super(*args)
    end

    desc 'expire', %q{Score expire.}
    def expire
      run Oursignal::Score::Expire
    end

    desc 'update', %q{Score update.}
    def update
      run Oursignal::Score::Update
    end

    protected
      def run(klass)
        klass.run
      rescue File::Pid::PidFileExist
        true
      end

    class Source < Thor
      def self.new(*args)
        Oursignal.merb_env
        require 'oursignal/score'
        super(*args)
      end

      desc 'delicious', %q{Score source delicious update.}
      def delicious
        run Oursignal::Score::Source::Delicious
      end

      desc 'digg', %q{Score source digg update.}
      def digg
        run Oursignal::Score::Source::Digg
      end

      desc 'frequency', %q{Score source frequency update.}
      def frequency
        run Oursignal::Score::Source::Frequency
      end

      desc 'freshness', %q{Score source freshness update.}
      def freshness
        run Oursignal::Score::Source::Freshness
      end

      desc 'reddit', %q{Score source reddit update.}
      def reddit
        run Oursignal::Score::Source::Reddit
      end

      desc 'ycombinator', %q{Score source ycombinator update.}
      def ycombinator
        run Oursignal::Score::Source::Ycombinator
      end

      protected
        def run(klass)
          klass.run
        rescue File::Pid::PidFileExist
          true
        end
    end
  end
end
