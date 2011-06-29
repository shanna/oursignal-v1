require 'oursignal/score/parser'

module Oursignal
  module Score
    class Parser
      #--
      # TODO: Facebook actually accepts a comma separated list of URLs without an API key.
      # Make less requests by chunking URLs if we can find an upper limit.
      class Facebook < Parser
        def urls
          urls = []
          links.each_slice(25) do |slice|
            urls << 'http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&format=json&urls=' + slice.map{|link| CGI.escape(link.url)}.join(',')
          end
          urls
        end

        def parse source
          data = Yajl::Parser.new(symbolize_keys: true).parse(source) || return
          data.each do |entry|
            link  = links.detect{|link| link.match?(entry[:url])} || next
            score = entry[:share_count] || next # Also like_count, comment_count, click_count and total_count if we need it.

            puts "facebook:link(#{link.id}, #{link.url}):#{score}"
            Link.execute("update links set score_facebook = ?, updated_at = now() where id = ?", score.to_i, link.id)
          end
        end
      end # Facebook
    end # Parser
  end # Score
end # Oursignal

__END__
[
  {
    "url": "http:\/\/google.com"
    "normalized_url": "http:\/\/www.google.com\/",
    "share_count": 763250,
    "like_count": 275286,
    "comment_count": 294467,
    "total_count": 1333003,
    "click_count": 265614,
    "comments_fbid": 383926826594
    "commentsbox_count": 0
  },
  {
    "url": "http:\/\/digg.com",
    "normalized_url": "http:\/\/www.digg.com\/",
    "share_count": 3486,
    "like_count": 399,
    "comment_count": 441,
    "total_count": 4326,
    "click_count": 1649,
    "comments_fbid": 387096841422,
    "commentsbox_count": 0
  }
]

