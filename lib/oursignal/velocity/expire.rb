require 'oursignal/job'

module Oursignal
  module Velocity
    class Expire < Job
      def call
        ::Velocity.repository.adapter.execute(%q{delete from velocities where created_at < ?}, (Time.now - 1.week).to_datetime)
      end
    end
  end
end
