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
      LIFETIME = 1_440

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
              extract(epoch from now() - referred_at)::int/60 as minutes,
              #{FIELDS.join(', ')}
            from links
            where referred_at > now() - interval '1 month'
          }) # Oh boy.
          puts "selected %d links in\t%10.4fs" % [links.count, Time.now - now]
          raise "Timestep requires a minimum of 100 links in the DB but only #{links.count} exist." unless links.count >= 100

          now     = Time.now
          result  = Flock.kcluster(100, links.map{|l| l.values_at(*FIELDS)}, seed: Flock::SEED_SPREADOUT)
          cluster = result[:cluster]
          puts "kmeans clustered in\t%10.4fs" % [Time.now - now]

          # TODO: Enumerable#inject avoids awkward kscores = Hash[kscores]
          # Creates a map of cluster number to index in sorted centroids array.
          now     = Time.now
          kscores = result[:centroid] \
            .map
            .with_index{|c, pos| [c, pos]}
            .sort_by{|el| Flock.euclidian_distance(el[0], ORIGIN)}
            .map
            .with_index{|(c, pos), idx| [pos, idx]}
          kscores = Hash[kscores]
          puts "scores mapped in\t%10.4fs" % [Time.now - now]

          now        = Time.now
          scores_ts  = 0
          scores_sth = Oursignal.db.prepare('select * from scores where link_id = ? order by timestep_id desc')
          links.each_with_index do |link, index|
            # Skip links older than 12 hours. Their scores will be zero by then anyway thanks to the decay.
            # This is done purely for performance.
            next if link[:minutes] > LIFETIME
            scores_ts += 1

            # The kmeans clustering score.
            kmeans = 0.01 * (kscores[cluster[index]] + 1)

            # TODO: Can be golfed if you select just the most recent score plus a count.
            # Will reduce the number of results (not queries) and will reduce the number of loops in Math::Ema by the
            # count. For now use this just in case the smoothing factor needs to be changed to a fixed number.
            scores = scores_sth.execute(link[:link_id]).entries

            # we got a single score just add a dummy score as first one
            # and assume this single score is the most recent one.
            scores.unshift({timestep_id: step.id, kmeans: kmeans}.merge(Hash[FIELDS.zip(ORIGIN)])) if scores.size < 2

            # TODO: Not perfect.
            displacement = Flock.euclidian_distance(link.values_at(*FIELDS), scores.first.values_at(*FIELDS))
            interval     = step.created_at.to_time - Oursignal::Timestep.get(id: scores.first[:timestep_id]).created_at.to_time
            velocity     = displacement / (interval + 0.1)

            # ema with smoothing factor 2/(N+1)
            ema = Math::Ema.new((2.0 / (scores.count + 1)), scores.shift[:kmeans]).update(scores.map{|row| row[:kmeans]})

            # Straight linear decay. KISS.
            decay = ema.to_f / LIFETIME
            score = [ema - (link.delete(:minutes).to_i * decay), 0].max

            # Add a score.
            Score.create({timestep_id: step.id, score: score, kmeans: kmeans, ema: ema, velocity: velocity}.merge(link))
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

