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
          data      = Yajl::Parser.new(symbolize_keys: true).parse(source).first || return
          score     = data[:total_posts] || return
          title     = data[:title]
          entry_url = 'http://www.delicious.com/url/' + data[:hash]

          puts "delicious:link(#{link.id}, #{link.url}):#{score}"
          @feed  ||= Feed.find('http://delicious.com/popular/') # TODO: Yuck.
          Resque::Job.create :entry, 'Oursignal::Job::Entry', @feed.id, entry_url, link.url, 'score_delicious', score, title
        end
      end # Delicious
    end # Native
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
  }
]
