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

      def name
        self.class.to_s.downcase.gsub(/[^:]+::/, '')
      end

      def pending
        # TODO: Probably going to have to be build/update an index.
        Link.all(:conditions => {
          :'$where' => %{
            if (!this.scores) return true;
            score = null;
            for (i = 0; i < this.scores.length; i++) {
              if (this.scores[i].source === #{name.to_json}) score = this.scores[i];
            }
            if (score) {
              if (!score.updated_at) return true;
              if (score.updated_at >= new Date(#{(Time.now - 60 * 30).to_json})) return false;
            }
            return true;
          }.gsub(/\s*\n\s*/, '')
        })
      end

      def score(urls = [])
        raise NotImplementedError
      end
    end # Source
  end # Score
end # Oursignal
