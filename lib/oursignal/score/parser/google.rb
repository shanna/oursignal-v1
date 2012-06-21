require 'oursignal/score/parser'

module Oursignal
  class Score
    class Parser
      class Google < Parser
        def urls
          links.map do |link|
            "https://plusone.google.com/u/0/_/%2B1/fastbutton?count=true&url=#{CGI.escape(link.url)}"
          end
        end

        def parse url, source
          url   = CGI.parse(URI.parse(url).query)['url'][0] rescue return
          link  = links.detect{|link| link.match?(url)} || return
          match = source.match(/window\.__SSR\s*=\s*{c:\s*(?<score>[\d.]+)/x) || return

          puts "google:link(#{link.id}, #{link.url}): #{match[:score]}"
          Link.execute('update links set score_google = ?, updated_at = now() where id = ?', match[:score], link.id)
        end
      end # Google
    end # Parser
  end # Score
end # Oursignal

__END__
HTML, Javascript and stuff. You are looking for 'c:' which is the +1's.

<script type="text/javascript">window.__SSR = {c: 119671.0 
