require 'oursignal/score/parser'

module Oursignal
  class Score
    class Parser
      class Facebook < Parser
        def urls
          urls   = []
          links.each_slice(25) do |slice|
            # Facebook API has issues with ' and ". Bad luck.
            escaped = slice.reject{|link| link.url.to_s =~ /['"]/}.map{|link| CGI.escape(link.url)}
            urls << 'http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&format=json&urls=' + escaped.join(',')
          end
          urls
        end

        def parse url, source
          data = Yajl.load(source, symbolize_keys: true) || return
          data.each do |entry|
            begin
              link  = links.detect{|link| link.match?(entry[:url])} || next
              score = entry[:share_count] || next # Also like_count, comment_count, click_count and total_count if we need it.

              puts "facebook:link(#{link.id}, #{link.url}):#{score}"
              Link.execute('update links set score_facebook = ?, updated_at = now() where id = ?', score.to_i, link.id)
            rescue => error
              warn ['Facebook Score Error:', caller.first, error.inspect, entry.inspect].join("\n")
            end
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

