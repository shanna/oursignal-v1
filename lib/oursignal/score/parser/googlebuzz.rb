require 'oursignal/score/parser'

module Oursignal
  module Score
    class Parser
      class Googlebuzz < Parser
        def urls
          urls = []
          links.each_slice(25) do |slice|
            urls << 'http://www.google.com/buzz/api/buzzThis/buzzCounter?' + slice.map{|link| 'url=' + CGI.escape(link.url)}.join('&')
          end
          urls
        end

        def parse source
          json = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^google_buzz_set_count\((.*)\)$/, "\\1")
          data = Yajl::Parser.new(symbolize_keys: true).parse(json) || return
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
