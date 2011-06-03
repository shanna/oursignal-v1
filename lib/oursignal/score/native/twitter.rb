require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Twitter < Native
        def url
          "http://urls.api.twitter.com/1/urls/count.json?url=#{URI.escape(link.url)}"
        end

        def parse source
          data  = Yajl::Parser.new(symbolize_keys: true).parse(source)
          score = data[:count] || return
          puts "twitter:link(#{link.id}, #{link.url}):#{score}"
          Link.execute("update links set score_twitter = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Twitter
    end # Native
  end # Score
end # Oursignal

