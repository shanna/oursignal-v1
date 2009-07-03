module Oursignal
  module Score

    class Source
      include EM::Deferrable

      cattr_accessor :sources
      def self.inherited(klass)
        (self.sources ||= []) << klass
      end

      def self.run
        score = new
        score.callback{ EM.add_timer(5, method(:run))}
        Thread.new do
          begin
            pending = score.pending
            score.score(pending) if (pending.is_a?(Array) && !pending.empty?)
          ensure
            score.succeed
          end
        end
      end

      def pending
        raise NotImplementedError
      end

      def score(urls = [])
        raise NotImplementedError
      end
    end # Source
  end # Score
end # Oursignal
