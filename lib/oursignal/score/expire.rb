require 'oursignal/job'

module Oursignal
  module Score
    class Expire < Job
      def call
        ::Score.repository.adapter.execute(%q{delete from scores where created_at < ?}, (Time.now - 1.week).to_datetime)
      end
    end
  end # Score
end # Oursignal

