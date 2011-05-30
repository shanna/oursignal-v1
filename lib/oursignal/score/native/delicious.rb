require 'digest/md5'

require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Delicious < Native
        def url
          "http://feeds.delicious.com/v2/json/urlinfo/blogbadge?hash=#{Digest::MD5.hexdigest(link.url)}"
        end

        def parse source
          data  = Yajl::Parser.new(symbolize_keys: true).parse(source)
          score = data.first[:total_posts] || return
          Link.execute("update links set score_delicious = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Delicious
    end # Native
  end # Score
end # Oursignal

