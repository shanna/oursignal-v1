module Oursignal
  module ScoredLink
    def self.find timestep_id, options = {}
      #--
      # TODO: View or stored procedure for this monster?
      links = Oursignal.db.execute(%q{
        select
          l.id,
          l.url,
          l.content_type,
          l.title,
          l.summary,
          l.tags,
          l.created_at,
          l.referred_at,
          s.score_digg,
          s.score_facebook,
          s.score_google,
          s.score_reddit,
          s.score_twitter,
          s.score_ycombinator,
          s.score
        from scores s
        join links l on (l.id = s.link_id)
        where s.timestep_id = ?
        order by s.score desc
        limit 50
      }, timestep_id)

      source_sth = Oursignal.db.prepare(%q{select e.url from entries e where e.link_id = ?})
      links.map do |link|
        link[:scores] = {
          digg:        link.delete(:score_digg),
          facebook:    link.delete(:score_facebook),
          google:      link.delete(:score_google),
          reddit:      link.delete(:score_reddit),
          twitter:     link.delete(:score_twitter),
          ycombinator: link.delete(:score_ycombinator)
        }

        # TODO: Cache against the link?
        link[:sources] = Hash[*source_sth.execute(link[:id]).map{|entry| [URI.domain(entry[:url]), entry[:url]]}.flatten]
        link
      end

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
