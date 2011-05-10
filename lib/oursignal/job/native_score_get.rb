require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Job
    class NativeScoreGet
      USER_AGENT = 'oursignal/0.3 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :native_score_get

      def self.perform source_klass
        source = Oursignal::Score::Native.find(source_klass)
        uri    = URI::IO.open(source.url) do |io|
          io.follow_location = true
          io.timeout         = 5
        end

        source.perform(uri) if uri.status.to_s =~ /^2/
      end
    end
  end # Job
end # Oursignal

