require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      #--
      # TODO: Digg actually accepts a comma separated list of URLs without an API key.
      # Make less requests by chunking URLs if we can find an upper limit.
      # http://services.digg.com/2.0/story.getInfo?links=
      # NOTE: While digging around the rate limit appears to be 5000 requests every 30 minutes according to the
      # X-RateLimit-* headers the documentation said would exist. Should be plenty once chunking is in place.
      class Digg < Native
        def url
          "http://widgets.digg.com/buttons/count?url=#{URI.escape(link.url)}"
        end

        def parse source
          json  = source.gsub(/^(.*);+\n*$/, "\\1").gsub(/^__DBW\.collectDiggs\((.*)\)$/, "\\1")
          data  = Yajl::Parser.new(symbolize_keys: true).parse(json)
          score = data[:diggs] || return

          puts "digg:link(#{link.id}, #{link.url}):#{score}"
          Link.execute("update links set score_digg = ?, updated_at = now() where id = ?", score.to_i, link.id)
        end
      end # Digg
    end # Native
  end # Score
end # Oursignal

__END__
Info response:
{
  count": 1, 
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

