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
      Oursignal::Score::Expire.run
    end

    desc 'update', %q{Score update.}
    def update
      Oursignal::Score::Update.run
    end

    class Source < Thor
      desc 'delicious', %q{Score source delicious update.}
      def delicious
        Oursignal::Score::Source::Delicious.run
      end

      desc 'digg', %q{Score source digg update.}
      def digg
        Oursignal::Score::Source::Digg.run
      end

      desc 'freshness', %q{Score source freshness update.}
      def freshness
        Oursignal::Score::Source::Freshness.run
      end

      desc 'reddit', %q{Score source reddit update.}
      def reddit
        Oursignal::Score::Source::Reddit.run
      end

      desc 'ycombinator', %q{Score source ycombinator update.}
      def ycombinator
        Oursignal::Score::Source::Ycombinator.run
      end
    end
  end
end
