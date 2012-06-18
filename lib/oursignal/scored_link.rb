module Oursignal
  module ScoredLink
    def self.find timestep_id, options = {}
      #--
      # TODO: View or stored procedure for this monster?
      links = Oursignal.db.execute(%q{
        select
          l.id,
          l.url,
          l.title,
          l.created_at,
          l.referred_at,
          s.score_digg,
          s.score_facebook,
          s.score_freshness,
          s.score_googlebuzz,
          s.score_reddit,
          s.score_twitter,
          s.score_ycombinator,
          s.score,
          s.velocity
        from scores s
        join links l on (l.id = s.link_id)
        where s.timestep_id = ?
        order by s.score desc
        limit 50
      }, timestep_id)

=begin
      # Moved to JS for now.

      # Log scale.
      min = links.min{|a, b| a[:score] <=> b[:score]}[:score]
      max = links.max{|a, b| a[:score] <=> b[:score]}[:score]
      links.map do |link|
        link[:score] = (Math.log(link[:score]) - Math.log(min)) / (Math.log(max) - Math.log(min))
        link
      end
=end
    end
  end # ScoredLink
end # Oursignal
