require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Digg < Native
        def url
          "http://widgets.digg.com/buttons/count?url=#{URI.escape(link.url)}"
        end

        def parse source
          json  = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^__DBW\.collectDiggs\((.*)\)$/, "\\1")
          data  = Yajl::Parser.new(symbolize_keys: true).parse(json)
          score = data[:diggs] || return
          Link.execute("update links set score_digg = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Digg
    end # Native
  end # Score
end # Oursignal

