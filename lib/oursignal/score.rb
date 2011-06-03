require 'flock'

require 'oursignal/link'

module Oursignal
  module Score
    FIELDS = %w{score_delicious score_digg score_facebook score_googlebuzz score_reddit score_twitter score_ycombinator}

    #--
    # TODO: Golf.
    def self.create
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

      Oursignal.db.execute(%Q{select id, #{FIELDS.join(', ')} from links}) do |link|
        # TODO: Find closest centroid (0.001 * (index + 1)) is your score.
      end
    end
  end # Score
end # Oursignal
