require 'flock'

require 'oursignal/score'
require 'oursignal/link'

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
      # TODO: Move to Score::Reader.perform
      # TODO: Centroids don't really need to be calculated every run. Perhaps once an hour?
      def self.perform
        links     = Oursignal.db.execute(%Q{select #{FIELDS.join(', ')} from links}) # Oh boy.
        clusters  = Flock.kmeans(100, links.map(&:values)) # TODO: Mask zeros?
        centroids = clusters[:centroid].sort_by{|c| Flock.euclidian_distance(c, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])}

        Oursignal.db.transaction :centroid_update do
          Oursignal.db.execute('delete from score_kmeans_centroids')
          insert = Oursignal.db.prepare(%Q{
            insert into score_kmeans_centroids (#{FIELDS.join(', ')}, score)
              values (?, ?, ?, ?, ?, ?, ?, ?)
          })
          centroids.each_with_index{|centroid, index| insert.execute(*centroid, (0.001 * (index + 1)))}
        end

        # TODO: Redundant code here.
        # TODO: Very loopy. Speed this shit up. C?
        # TODO: Velocity.
        # TODO: Decay?
        Oursignal.db.execute(%Q{select id, url, #{FIELDS.join(', ')} from links}) do |link|
          vector  = link.values_at(*FIELDS)
          closest = centroids.sort_by{|c| Flock.euclidian_distance(vector, c)}.first
          score   = (0.01 * (centroids.index(closest) + 1))

          # TODO: Insert current native scores, calculated score, velocity and decay into score_timeseries for the
          # current series tick. Use a series table with an auto_incrementing primary key for ticks or use a time
          # scheme in 5 minute chunks?
          distance = Flock.euclidian_distance(vector, closest)
          puts "link: #{score} - #{distance} - #{link[:url]}"
        end
      end
    end # Timestep
  end # Score
end # Oursignal
