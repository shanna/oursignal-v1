require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Reddit < Native
        def url
          "http://buttons.reddit.com/button_info.json?url=#{URI.escape(link.url)}"
        end

        def parse source
          entry     = Yajl::Parser.new(symbolize_keys: true).parse(source)[:data][:children].first || return
          data      = entry[:data]      || return
          score     = data[:score].to_i || return
          title     = data[:title]
          entry_url = 'http://www.reddit.com/' + data[:permalink]

          puts "reddit:link(#{link.id}, #{link.url}):#{score}"
          @feed ||= Feed.find('http://www.reddit.com/.json') # TODO: Yuck.
          Resque::Job.create :entry, 'Oursignal::Job::Entry', @feed.id, entry_url, link.url, 'score_reddit', score, title
        end
      end # Reddit
    end # Native
  end # Score
end # Oursignal

__END__
{
  "kind": "Listing",
  "data": {
    "modhash": "",
    "children": [
      {
        "kind": "t3",
        "data": {
          "domain": "warpprism.com",
          "media_embed": {},
          "levenshtein": null,
          "subreddit": "starcraft",
          "selftext_html": null,
          "selftext": "",
          "likes": null,
          "saved": false,
          "id": "hrt42",
          "clicked": false,
          "author": "jakefrink",
          "media": null,
          "score": 505,
          "over_18": false,
          "hidden": false,
          "thumbnail": "/static/noimage.png",
          "subreddit_id": "t5_2qpp6",
          "downs": 318,
          "is_self": false,
          "permalink": "/r/starcraft/comments/hrt42/hi_rstarcraft_been_hacking_away_for_a_few_hours/",
          "name": "t3_hrt42",
          "created": 1307257883.0,
          "url": "http://warpprism.com/mlg",
          "title": "Hi /r/starcraft!  Been hacking away for a few hours to make a Warp Prism dedicated MLG Watcher.  It has HQ Support and Fast Switching.  Let me know what you think!",
          "created_utc": 1307232683.0,
          "num_comments": 104,
          "ups": 823
        }
      }
    ],
    "after": null,
    "before": null
  }
}
