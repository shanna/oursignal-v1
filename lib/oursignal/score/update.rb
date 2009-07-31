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
              Merb.logger.error("score\terror\nfailed to update link\n#{link.errors.full_messages}")
            end
          end
          Merb.logger.debug("score\t%.5f\t%.5f\t%s" % [link.score, link.velocity, link.url])
        end
      end

      protected
        def score(link)
          sources = ::Score.all(:url => link.url).map{|score| [score.source, score.score]}.to_mash
          return 0.to_f if sources.empty?

          scores = sources.map do |source, score|
            # No out of range error, use 1.0
            find = buckets(source).find{|r| score <= r} || buckets(source).last
            (buckets(source).index(find).to_f + 1) / buckets(source).size
          end

          # TODO: Simple average for now but change it to bayesian average using number of scores.
          average = (scores.inject(&:+).to_f / scores.size)
          final   = average unless average.infinite?

          # Degrade over time.
          age   = (1.to_f / ((Time.now - link.created_at.to_time).to_i / 6.hours))
          final = final * age unless age.infinite?

          final
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

