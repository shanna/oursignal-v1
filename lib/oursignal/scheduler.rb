require 'daemons'
require 'eventmachine'
require 'rufus-scheduler'
require 'oursignal/feed'
require 'oursignal/score'
require 'oursignal/velocity'

module Oursignal
  class Scheduler < Job
    def self.run(daemonize = false)
      # Process.daemon if daemonize # 1.9 only.
      Daemons.daemonize if daemonize
      super()
    end

    def call
      EM.run do
        s = Rufus::Scheduler::EmScheduler.start_new
        s.every('10m'){ Oursignal::Feed::Expire.run}
        s.every('1m'){ Oursignal::Feed::Update.run}
        s.every('1m'){ Oursignal::Feed::Meta.run}

        s.every('1h', :first_in => '11m'){ Oursignal::Velocity::Update.run}
        s.every('1d', :first_in => '21m'){ Oursignal::Velocity::Expire.run}

        s.every('15m'){ Oursignal::Score::Expire.run}
        s.every('1m'){ Oursignal::Score::Update.run}

        s.every('5m'){ Oursignal::Score::Source::Freshness.run}
        s.every('5m', :first_in => '2m30s'){ Oursignal::Score::Source::Frequency.run}
        s.every('15m', :first_in => '2m'){ Oursignal::Score::Source::Delicious.run}
        s.every('15m', :first_in => '4m'){ Oursignal::Score::Source::Digg.run}
        s.every('15m', :first_in => '6m'){ Oursignal::Score::Source::Reddit.run}
        s.every('15m', :first_in => '8m'){ Oursignal::Score::Source::Ycombinator.run}
      end
    end
  end # Scheduler
end # Oursignal

