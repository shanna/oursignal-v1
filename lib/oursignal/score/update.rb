require 'oursignal/job'

module Oursignal
  module Score
    class Update < Job
      self.poll_time = 5

      def initialize(*args)
        super
        @buckets = {}
      end

      def poll
        # TODO: I can build an 'OR' with DM::Query even if the class finders can't do it yet.
        links = Link.all(:score_at.lt => (Time.now - 5.minutes).to_datetime)
        links + Link.all(:score_at => nil)
      end

      def work(links)
        Merb.logger.info("score\tupdating scores for #{links.size} links") unless links.empty?
        links.each do |link|
          begin
            new_score     = score(link)
            link.velocity = (new_score - (link.score || 0)) if new_score != link.score
            link.score    = new_score
          rescue => error
            Merb.logger.error("score\terror\n#{error.message}\n#{error.backtrace.join($/)}")
          ensure
            link.score_at = DateTime.now
            unless link.save
              Merb.logger.error("score\terror\nfailed to update link\n#{link.errors.full_messages.join($/)}")
            end
          end
          Merb.logger.debug("score\t%.5f\t%.5f\t%s" % [link.score, link.velocity, link.url])
        end
      end

      protected
        def score(link)
          sources = link.scores.map{|score| [score.source, score.score]}.to_mash
          return 0.to_f if sources.empty?

          scores = sources.map do |source, score|
            # No out of range error, use 1.0
            find = buckets(source).find{|r| score <= r} || buckets(source).last
            (buckets(source).index(find).to_f + 1) / buckets(source).size
          end

          # TODO: The score is a simple average across the sources for now.
          # It'd probably be better with some more fancy maths.
          average = (scores.inject(&:+).to_f / scores.size)
          final   = average unless average.infinite?
          final

          # TODO: Use the number of sources for this link divided by the total possible sources to adjust the final score
          # back towards the average score. Less sources equals something closer to the average while more sources is
          # closer to the current final score.
          # http://www.thebroth.com/blog/118/bayesian-rating
        end

        #--
        # TODO: Cache (Memcache?) the bucket list?
        def buckets(source)
          return @buckets[source] if @buckets[source]

          partition        = 100 # TODO: Remove magic number.
          scores           = ::Score.all(:source => source, :order => [:score.asc]).map(&:score)
          @buckets[source] = (1 .. partition).to_a.map! do |r|
            scores.at((scores.size * (r.to_f / partition)).to_i) || scores.last
          end
          @buckets[source]
        end

    end # Update
  end # Score
end # Oursignal

