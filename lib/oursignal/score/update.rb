require 'oursignal/job'
require 'oursignal/score/source'
require 'math/uniform_distribution'
require 'math/average/exponential_moving'

module Oursignal
  module Score
    class Update < Job
      PRECISION   = 100
      MAX_SOURCES = Oursignal::Score::Source.subclasses.size

      def call
        # TODO: I can build an 'OR' with DM::Query even if the class finders can't do it yet.
        links =  Link.all(:score_at.lt => (Time.now - 5.minutes).to_datetime)
        links += Link.all(:score_at => nil)
        unless links.empty?
          Merb.logger.info("score\tupdating scores for #{links.size} links") unless links.empty?
          links.each do |link|
            begin
              age           = ((Time.now - link.referred_at.to_time).to_f / 1.hour)
              new_score     = score(link) / ((age + 2) ** 1.5)
              ema           = Math::Average::ExponentialMoving.new(0.9, (link.velocity || 0))
              link.velocity = ema.update(new_score - (link.score || 0))
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
      end

      protected
        def score(link)
          sources = link.scores.map{|score| [score.source, score.score]}.to_mash
          return 0.to_f if sources.empty?

          scores = sources.map do |source, score|
            ud = buckets(source)
            (ud.at(score).to_f + 1) / ud.buckets
          end

          # The score is a simple average across the sources for now.
          average = (scores.inject(&:+).to_f / scores.size)
          final   = average unless average.infinite?

          # Adjust the score by the number of score sources. John says the aggressiveness of this algorithm may need
          # to be tweaked to our tastes but you'll have to ask him for more black magic since this goes beyond my high
          # school maths :)
          final *= (Math.log(scores.size + 1) / Math.log(MAX_SOURCES + 1)) if scores.size >= 1

          Merb.logger.debug(%Q{score\t%s
            \r  sources %d
            \r  scores  %s
            \r  average %.5f
            \r  final   %.5f
          } % [link.url, sources.size, scores.join(','), average, final])

          final
        end

        def buckets(source)
          Math::UniformDistribution.new([self.class.to_s.downcase, source].join(':'), 1.hour) do
            scores = ::Score.repository.adapter.query(
              %q{select score from scores where source = ? order by score asc}, source
            )
            (1 .. PRECISION).to_a.map! do |r|
              scores.at((scores.size * (r.to_f / PRECISION)).to_i) || scores.last
            end
          end
        end

    end # Update
  end # Score
end # Oursignal

