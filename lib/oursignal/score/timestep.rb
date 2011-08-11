require 'flock'
require 'math/ema'

require 'oursignal/link'
require 'oursignal/score'
require 'oursignal/timestep'

module Oursignal
  class Score
    module Timestep
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
      def self.perform
        Oursignal.db.transaction do
          step  = Oursignal::Timestep.create
          links = Oursignal.db.execute(%Q{select id as link_id, #{FIELDS.join(', ')} from links}) # Oh boy.
          raise 'Timestep requires a minimum of 100 links in the DB.' unless links.count >= 100

          clusters  = Flock.kmeans(100, links.map{|l| l.values_at(*FIELDS)}) # TODO: Mask zeros?
          centroids = clusters[:centroid].sort_by{|c| Flock.euclidian_distance(c, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])}

          # TODO: Very loopy. Speed this shit up. C?
          # TODO: Decay?
          links.each do |link|
            vector  = link.values_at(*FIELDS)
            closest = centroids.sort_by{|c| Flock.euclidian_distance(vector, c)}.first
            score   = (0.01 * (centroids.index(closest) + 1))

            # TODO: Can be golfed if you select just the most recent score plus a count.
            # Might not reduce the DB load but will reduce the number of loops in Math::Ema by the count.
            # For now use this just in case the smoothing factor needs to be changed to a fixed number.
            scores = Score.execute('select score from scores where link_id = ? order by timestep_id desc', link[:id]).to_a
            ema    = Math::Ema.new((2.0 / (scores.count + 1)), 0).update(scores << score) # Smoothing factor 2/(N+1)

            # Vanilla difference between ema and score.
            velocity = score - ema

            Score.create({timestep_id: step.id, score: score, ema: ema, velocity: velocity}.merge(link))
          end
        end
      end
    end # Timestep
  end # Score
end # Oursignal

