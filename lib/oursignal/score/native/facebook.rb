require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Facebook < Native
        def url
          "http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&urls=#{URI.escape(link.url)}&format=json&callback=fb_sharepro_render"
        end

        def parse source
          json  = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^fb_sharepro_render\((.*)\)$/, "\\1")
          data  = Yajl::Parser.new(symbolize_keys: true).parse(json)
          score = data.first[:share_count] || return # Also like_count, comment_count, click_count and total_count if we need it.
          puts "facebook:link(#{link.id}, #{link.url}):#{score}"
          Link.execute("update links set score_facebook = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Facebook
    end # Native
  end # Score
end # Oursignal

