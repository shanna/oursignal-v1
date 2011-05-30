require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Job
    class ScoreNativeGet
      USER_AGENT = 'oursignal/0.3 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :score_native_get

      def self.perform source_klass, link_id
        source = Oursignal::Score::Native.find(source_klass) || return
        link   = Oursignal::Link.get(id: link_id)            || return
        score  = source.new(link)
        uri = URI::IO.open(score.url) do |io|
          io.follow_location = true
          io.timeout         = 5

          io.headers['User-Agent'] = USER_AGENT
        end
        score.parse(uri) if uri.status.to_s =~ /^2/
      end
    end # ScoreNativeGet
  end # Job
end # Oursignal

