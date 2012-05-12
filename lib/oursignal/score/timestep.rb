require 'flock'
require 'math/ema'

require 'oursignal/link'
require 'oursignal/score'
require 'oursignal/timestep'

module Oursignal
  class Score
    module Timestep
      ORIGIN = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
      FIELDS = [
        :score_delicious,
        :score_digg,
        :score_facebook,
        :score_googlebuzz,
        :score_reddit,
        :score_twitter,
        :score_ycombinator
      ]

      #--
      # TODO: Golf.
      # TODO: Decay.
      def self.perform
        Oursignal.db.transaction do
          step  = Oursignal::Timestep.create
          links = Oursignal.db.execute(%Q{select id as link_id, #{FIELDS.join(', ')} from links}) # Oh boy.
          raise "Timestep requires a minimum of 100 links in the DB but only #{links.count} exist." unless links.count >= 100

          result  = Flock.kcluster(100, links.map{|l| l.values_at(*FIELDS)}, seed: Flock::SEED_SPREADOUT)
          cluster = result[:cluster]

          # TODO: Enumerable#inject avoids awkward kscores = Hash[kscores]
          # Creates a map of cluster number to index in sorted centroids array.
          kscores = result[:centroid] \
            .map
            .with_index{|c, pos| [c, pos]}
            .sort_by{|el| Flock.euclidian_distance(el[0], ORIGIN)}
            .map
            .with_index{|(c, pos), idx| [pos, idx]}
          kscores = Hash[kscores]

          links.each_with_index do |link, index|
            kmeans  = 0.01 * (kscores[cluster[index]] + 1)

            # TODO: Can be golfed if you select just the most recent score plus a count.
            # Might not reduce the DB load but will reduce the number of loops in Math::Ema by the count.
            # For now use this just in case the smoothing factor needs to be changed to a fixed number.
            sql     = 'select * from scores where link_id = ? order by timestep_id desc'
            scores  = Score.execute(sql, link[:id]).to_a.unshift({timestep_id: step.id, kmeans: kmeans}.merge(Hash[FIELDS.zip(ORIGIN)]))

            # TODO: Not perfect.
            displacement = Flock.euclidian_distance(link.values_at(*FIELDS), scores.first.values_at(*FIELDS))
            interval     = step.created_at.to_time - Oursignal::Timestep.get(id: scores.first[:timestep_id]).created_at.to_time
            velocity     = displacement / (interval + 0.1)

            # ema with smoothing factor 2/(N+1)
            ema = Math::Ema.new((2.0 / (scores.count + 1)), scores.shift[:kmeans]).update(scores.map{|row| row[:kmeans]})

            # Decay.
            # TODO: Decay by mean lifetime a link exists in feeds perhaps? I can't actually calculate that yet.
            score = kmeans

            Score.create({timestep_id: step.id, score: score, kmeans: kmeans, ema: ema, velocity: velocity}.merge(link))
          end
        end
      end
    end # Timestep
  end # Score
end # Oursignal

