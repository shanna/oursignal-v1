require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Googlebuzz < Native
        def url
          "http://www.google.com/buzz/api/buzzThis/buzzCounter?url=#{URI.escape(link.url)}"
        end

        def parse source
          json  = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^google_buzz_set_count\((.*)\)$/, "\\1")
          data  = Yajl::Parser.new(symbolize_keys: true).parse(json)
          score = data.values.first || return
          puts "googlebuzz:link(#{link.id}, #{link.url}):#{score}"
          Link.execute("update links set score_googlebuzz = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Googlebuzz
    end # Native
  end # Score
end # Oursignal

__END__
google_buzz_set_count({"http://teamliquid.net":600});
