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
        # Fucked if I know whats going on here but I can't + these together even if I .to_a
        links = Link.all(:conditions => {:score => nil})
        links << Link.all(:conditions => {:scored_at => nil})
        links << Link.all(:conditions => {:scored_at => {:'$lt' => Time.now - 60 * 15}})
        links = links.flatten.uniq

        Merb.logger.info("#{self.class}: Updating scores for #{links.size} links...") unless links.empty?
        links
      end

      def work(links)
        links.each do |link|
          begin
            score         = score(link.url)
            link.velocity = score - (link.score || 0)
            link.score    = score
          ensure
            link.scored_at = Time.now
            link.save
          end
        end
      end

      protected
        def score(url)
          sources = ::Score.all(:conditions => {:url => url}).map{|score| [score.source, score.score]}.to_mash
          return 0.to_f if sources.empty?

          scores  = sources.map do |source, score|
            # No out of range error, use 1.0
            find = buckets(source).find{|r| score <= r} || buckets(source).last
            (buckets(source).index(find).to_f + 1) / buckets(source).size
          end

          # TODO: Simple average for now but change it to bayesian average using number of scores.
          scores.inject(&:+).to_f / scores.size
        end

        #--
        # TODO: Cache (Memcache?) the bucket list?
        def buckets(source)
          return @buckets[source] if @buckets[source]

          partition        = 100 # TODO: Remove magic number.
          scores           = ::Score.all(:conditions => {:source => source}, :order => 'score asc').map(&:score)
          @buckets[source] = (1 .. partition).to_a.map! do |r|
            scores.at((scores.size * (r.to_f / partition)).to_i) || scores.last
          end
          @buckets[source]
        end

    end # Update
  end # Score
end # Oursignal

