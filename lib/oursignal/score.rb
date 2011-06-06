require 'flock'

require 'oursignal/link'

module Oursignal
  module Score
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
    def self.read
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
        link_distance = Flock.euclidian_distance(link.values_at(*FIELDS), [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
        # TODO: Clearly calculating and recalculating the distance from zeros is dumb. I'll get to optimizin' later since
        # it's still fast as fuck already.
        score = 0.0
        centroids.each_with_index do |centroid, index|
          break if link_distance <= Flock.euclidian_distance(centroid, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
          score = (0.01 * (index + 1))
        end

        # TODO: Insert current native scores, calculated score, velocity and decay into score_timeseries for the
        # current series tick. Use a series table with an auto_incrementing primary key for ticks or use a time
        # scheme in 5 minute chunks?
        puts "link: #{score} - #{link_distance} - #{link[:url]}"
      end
    end
  end # Score
end # Oursignal
