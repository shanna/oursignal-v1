require 'digest/md5'

require 'oursignal/score/parser'

module Oursignal
  class Score
    class Parser
      class Delicious < Parser
        def urls
          urls = []
          links.each_slice(25) do |slice|
            urls << 'http://feeds.delicious.com/v2/json/urlinfo/blogbadge?' + slice.map{|link| 'hash=' + Digest::MD5.hexdigest(link.url)}.join('&')
          end
          urls
        end

        def parse source
          feed = Feed.find('http://delicious.com') || return
          data = Yajl::Parser.new(symbolize_keys: true).parse(source) || return
          data.each do |entry|
            link      = links.detect{|link| link.match?(entry[:url])} || next
            score     = entry[:total_posts] || next
            title     = entry[:title]
            entry_url = 'http://www.delicious.com/url/' + entry[:hash]

            puts "delicious:link(#{link.id}, #{link.url}):#{score}"
            Entry.upsert url: entry_url, feed_id: feed.id, link: {url: link.url, score_delicious: score, title: title}
          end
        end
      end # Delicious
    end # Parser
  end # Score
end # Oursignal

__END__
[
  {
    "hash": "0d1838a6d091987bdc3f9e7986312b94",
    "title": "Sea levels set to rise by up to a metre: report",
    "url": "http:\/\/www.physorg.com\/news\/2011-05-sea-metre.html",
    "total_posts": 1,
    "top_tags":[]
  },
  ...
]
