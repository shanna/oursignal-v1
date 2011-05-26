require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Job
    class NativeScoreGet
      USER_AGENT = 'oursignal/0.3 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :native_score_get

      def self.perform source_klass, source_url = nil
        source = Oursignal::Score::Native.find(source_klass)

        if source_url
          uri = URI::IO.open(source_url) do |io|
            io.follow_location = true
            io.timeout         = 5
          end
          source.perform(uri) if uri.status.to_s =~ /^2/
        else
          [*source.url].each{|url| Resque::Job.create :native_score_get, self, source_klass, url}
        end
      end
    end
  end # Job
end # Oursignal

