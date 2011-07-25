require 'flock'

require 'oursignal/link'
require 'oursignal/score'
require 'oursignal/timestep'

module Oursignal
  module Score
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
        # TODO: Score class and scheme.
        insert_score = Oursignal.db.prepare(%Q{
          insert into scores (timestep_id, link_id, #{FIELDS.join(', ')}, score, velocity)
          values (?, ?, #{FIELDS.map{|f| '?'}.join(', ')}, ?, ?)
        })

        Oursignal.db.transaction do
          step  = Timestep.create
          links = Oursignal.db.execute(%Q{select id, url, #{FIELDS.join(', ')} from links}) # Oh boy.
          raise 'Timestep requires a minimum of 100 links in the DB.' unless links.count >= 100

          clusters  = Flock.kmeans(100, links.map{|l| l.values_at(*FIELDS)}) # TODO: Mask zeros?
          centroids = clusters[:centroid].sort_by{|c| Flock.euclidian_distance(c, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])}

          # TODO: Very loopy. Speed this shit up. C?
          # TODO: Decay?
          links.each do |link|
            vector  = link.values_at(*FIELDS)
            closest = centroids.sort_by{|c| Flock.euclidian_distance(vector, c)}.first
            score   = (0.01 * (centroids.index(closest) + 1))

            # TODO: Velocity.
            insert_score.execute(step.id, link[:id], *vector, score, nil)
            puts "link: #{score} - #{link[:url]}"
          end
        end
      end
    end # Timestep
  end # Score
end # Oursignal
