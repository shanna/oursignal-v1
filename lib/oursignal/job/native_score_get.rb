require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Job
    class NativeScoreGet
      USER_AGENT = 'oursignal/0.3 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :native_score_get

      #--
      # TODO: Split up multiple URLs reads.
      def self.perform source_klass
        source = Oursignal::Score::Native.find(source_klass)
        [source.url].flatten.each do |url|
          uri = URI::IO.open(url) do |io|
            io.follow_location = true
            io.timeout         = 5
          end

          source.perform(uri) if uri.status.to_s =~ /^2/
        end
      end
    end
  end # Job
end # Oursignal

