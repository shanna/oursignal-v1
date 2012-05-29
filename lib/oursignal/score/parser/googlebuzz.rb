require 'oursignal/score/parser'

module Oursignal
  class Score
    class Parser
      class Googlebuzz < Parser
        def urls
          urls = []
          links.each do |link|
            escaped = 'url=' + CGI.escape(link.url)
            if urls[-1] && (urls[-1] + '&' + escaped).length < 2000
              urls[-1] ||= '&' + escaped
            else
              urls << 'http://www.google.com/buzz/api/buzzThis/buzzCounter?' + escaped
            end
          end
          urls
        end

        def parse source
          json = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^google_buzz_set_count\((.*)\)$/, "\\1")
          data = Yajl.load(json, symbolize_keys: true) || return
          data.each do |url, score|
            link = links.detect{|link| link.match?(url)} || next

            puts "googlebuzz:link(#{link.id}, #{link.url}): #{score}"
            Link.execute('update links set score_googlebuzz = ?, updated_at = now() where id = ?', score.to_i, link.id)
          end
        end
      end # Googlebuzz
    end # Parser
  end # Score
end # Oursignal

__END__
google_buzz_set_count({"http://teamliquid.net":600}, ...);
