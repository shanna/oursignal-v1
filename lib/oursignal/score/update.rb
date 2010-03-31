require 'oursignal/job'
require 'math/uniform_distribution'
require 'math/average/exponential_moving'

module Oursignal
  module Score
    class Update < Job

      def score_normalized source, score
        ((score_normalizer(source).at(score).to_f + 1) / 100).round(2)
      end

      def score_normalizer source
        Math::UniformDistribution.new('score_' + source) do
          total = ::Score.count(:source => source)
          last  = ::Score.first(:order => [:score.desc], :source => source).score
          (1 .. 100).to_a.map! do |range|
            offset = (total * (range.to_f / 100)).to_i
            score  = ::Score.first(:source => source, :order => [:score.asc], :offset => offset)
            score ? score.score : last
          end
        end
      end

      def link_age referred_at
        hours = (Time.now - referred_at.to_time).to_f / 1.hour
        hours < 24 ? ((24.to_f - hours) / 24) : 0.to_f
      end

      def call
        links = repository.adapter.query(%q{
          select id, url, referred_at, score_average, score_bonus, score, velocity_average, velocity
          from links
          where score_at < ? or score_at is null
        }, (Time.now - 15.minutes).to_datetime)

        unless links.empty?
          links.each do |link|
            scores = repository.adapter.query(%q{
              select source, score
              from scores
              where url = ?
            }, link.url)
            next if scores.empty?

            age           = link_age(link.referred_at)
            score_average = scores.map{|score| score_normalized(score.source, score.score)}.inject(&:+) / scores.size
            score_bonus   = scores.size.to_f / ::Score.sources.size
            score         = score_average * (0.1 * score_bonus + 0.9) * age

            ema              = Math::Average::ExponentialMoving.new(0.5, (link.velocity_average || 0))
            velocity_average = ema.update(score - (link.score || 0))
            velocity         = ::Velocity.normalized(velocity_average)

            repository.adapter.execute(
              %q{
                update links
                set
                  score_average    = ?,
                  score_bonus      = ?,
                  score            = ?,
                  velocity_average = ?,
                  velocity         = ?,
                  score_at         = now()
                where
                  id = ?
              },
              score_average.to_f.round(5),
              score_bonus.to_f.round(5),
              score.to_f.round(5),
              velocity_average.to_f.round(5),
              velocity.to_f.round(5),
              link.id
            )

            puts %Q{%s, %s
              \r  age: %.5f
              \r  old:
              \r    score_average:    %.5f
              \r    score_bonus:      %.5f
              \r    score:            %.5f
              \r    velocity_average: %.5f
              \r    velocity:         %.5f
              \r  new:
              \r    score_average:    %.5f
              \r    score_bonus:      %.5f
              \r    score:            %.5f
              \r    velocity_average: %.5f
              \r    velocity:         %.5f
            } % [
              link.id,
              link.url,
              age,
              link.score_average,
              link.score_bonus,
              link.score,
              link.velocity_average,
              link.velocity,
              score_average,
              score_bonus,
              score,
              velocity_average,
              velocity
            ]
          end
        end
      end

    end # Update
  end # Score
end # Oursignal

