require 'oursignal/score/parser'

module Oursignal
  module Score
    class Parser
      #--
      # NOTE: While digging around the rate limit appears to be 5000 requests every 30 minutes according to the
      # X-RateLimit-* headers the documentation said would exist. Should be plenty once chunking is in place.
      class Digg < Parser
        def urls
          urls = []
          links.each_slice(25) do |slice|
            urls << 'http://services.digg.com/2.0/story.getInfo?links=' + slice.map{|link| CGI.escape(link.url)}.join(',')
          end
          urls
        end

        def parse source
          feed = Feed.find('http://digg.com') || return
          data = Yajl::Parser.new(symbolize_keys: true).parse(source) || return
          (data[:stories] || []).each do |entry|
            link      = links.detect{|link| link.match?(entry[:url])} || next
            score     = entry[:diggs].to_i || next
            title     = entry[:title]
            entry_url = entry[:permalink]

            puts "digg:link(#{link.id}, #{link.url}): #{score}"
            Entry.upsert url: entry_url, feed_id: feed.id, link: {url: link.url, score_digg: score, title: title}
          end
        end
      end # Digg
    end # Parser
  end # Score
end # Oursignal

__END__
Info response:
{
  "count": 1,
  "timestamp": 1307457296,
  "cursor": "",
  "version": "2.0",
  "stories": [
    {
      "status": "upcoming",
      "permalink": "http://digg.com/news/business/bm_from_local",
      "description": "notes",
      "title": "BM from Local",
      "url": "http://google.com",
      "story_id": "20110607120516:1de2307f-86db-477d-b4ce-264d0993e37a",
      "diggs": 1,
      "submiter": {
        "username": "ezestosm",
        "about": "",
        "user_id": "7225238",
        "name": "",
        "icons": [
          "http://cdn3.diggstatic.com/img/user/c.png",
          "http://cdn3.diggstatic.com/img/user/h.png",
          "http://cdn1.diggstatic.com/img/user/m.png",
          "http://cdn3.diggstatic.com/img/user/l.png",
          "http://cdn3.diggstatic.com/img/user/p.png",
          "http://cdn1.diggstatic.com/img/user/s.png",
          "http://cdn3.diggstatic.com/img/user/r.png"
        ],
        "gender": "",
        "diggs": 481,
        "comments": 2,
        "followers": 3,
        "location": "",
        "following": 2,
        "submissions": 470,
        "icon": "http://cdn1.diggstatic.com/img/user/p.png"
      },
      "comments": 0,
      "dugg": 0,
      "topic": {
        "clean_name": "business",
        "name": "Business"
      },
      "promote_date": null,
      "activity": [],
      "date_created": 1307448316,
      "thumbnails": {
        "large": "http://cdn1.diggstatic.com/story/bm_from_local/l.png",
        "small": "http://cdn1.diggstatic.com/story/bm_from_local/s.png",
        "medium": "http://cdn1.diggstatic.com/story/bm_from_local/m.png",
        "thumb": "http://cdn3.diggstatic.com/story/bm_from_local/t.png"
      }
    }
  ],
  "authorized": 0,
  "data": "stories",
  "method": "story.getInfo",
  "user": null
}

