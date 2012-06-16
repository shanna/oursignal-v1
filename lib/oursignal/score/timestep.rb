require 'flock'
require 'math/ema'

require 'oursignal/link'
require 'oursignal/score'
require 'oursignal/timestep'

# TODO:
# 1. i'm still not convinced about the clustering given scores are so sparse and varied.
# 2. tweak decay rates, i suspect it might be a bit too pessimistic as is.

module Oursignal
  class Score
    module Timestep
      FIELDS = Score.sources
      ORIGIN = Array.new(FIELDS.size, 0.0)

      # Link lifetime from referred_at.
      # LIFETIME = 1_440 # 24 hours in minutes.
      LIFETIME = 86_400 # 24 hours

      #--
      # TODO: Golf.
      # TODO: Smaller methods.
      # TODO: C++. This isn't performing well enough.
      def self.perform
        Oursignal.db.transaction do
          now   = Time.now
          step  = Oursignal::Timestep.create
          links = Oursignal.db.execute(%Q{
            select
              id as link_id,
              extract(epoch from now() - referred_at)::int as seconds,
              #{FIELDS.join(', ')}
            from links
            where referred_at > now() - interval '#{LIFETIME} seconds'
          })
          puts "selected %d links in\t%10.4fs" % [links.count, Time.now - now]
          raise "Timestep requires a minimum of 100 links in the DB but only #{links.count} exist." unless links.count >= 100

          buckets = Score.sources.inject({}) do |buckets, source|
            sb = ScoreBucket.find(source)
            buckets[source] = sb if sb
            buckets
          end

          now        = Time.now
          scores_ts  = 0
          scores_sth = Oursignal.db.prepare('select * from scores where link_id = ? and bucket > 0 order by timestep_id desc')
          links.each_with_index do |link, index|
            scores_ts += 1
            bucket_scores = Score.sources.inject([]) do |acc, source|
              acc << buckets[source].at(link[source]) if buckets[source]
              acc
            end.select{|score| score > 0}
            next if bucket_scores.empty?

            bucket_average = bucket_scores.inject(:+) / bucket_scores.size
            bucket_bonus   = bucket_scores.size.to_f / Score.sources.size
            bucket         = bucket_average * (0.1 * bucket_bonus + 0.9)
            # pp({size: bucket_scores.size, scores: bucket_scores, average: bucket_average, bonus: bucket_bonus, bucket: bucket})

            # TODO: Can be golfed if you select just the most recent score plus a count.
            # Will reduce the number of results (not queries) and will reduce the number of loops in Math::Ema by the
            # count. For now use this just in case the smoothing factor needs to be changed to a fixed number.
            scores = scores_sth.execute(link[:link_id]).entries.push(bucket: bucket)

            # ema with smoothing factor 2/(N+1)
            ema = Math::Ema.new((2.0 / (scores.count + 1)), scores.shift[:bucket]).update(scores.map{|row| row[:bucket]})

            # Straight linear decay. KISS.
            decay = ema.to_f / LIFETIME
            score = [ema - (link.delete(:seconds).to_i * decay), 0].max
            # decay = bucket / LIFETIME
            # score = [bucket - (link.delete(:seconds).to_i * decay), 0].max

            # Add a score.
            Score.create({timestep_id: step.id, score: score, ema: ema, bucket: bucket}.merge(link))
          end
          puts "created %d scores in\t%10.4fs" % [scores_ts, Time.now - now]

          # Not enough links in timestep? Ditch it.
          if scores_ts < 100
            warn "Only %d scores, ditching transaction." % scores_ts
            Swift.db.rollback
          end
        end # .transaction
      end # .perform
    end # Timestep
  end # Score
end # Oursignal

