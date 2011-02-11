require 'oursignal/job'
require 'uri/io'
require 'yajl'

require 'oursignal/scheme/link'

module Oursignal
  module Job
    class NativeScoreReddit
      USER_AGENT = 'oursignal/0.2 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :native_score_reddit

      def self.perform
        uri = URI::IO.open('http://www.reddit.com/.json') do |io|
          io.follow_location = true
          io.timeout         = 10
        end

        update = Oursignal.db.prepare(%q{
          update links
          set native_score_reddit = ?
          where url in (
            select l.url
            from links l
            left join entry_links el on (el.link_id = l.id)
            left join entries e on (e.id = el.entry_id)
            where l.url = ? or e.url = ?
          )
        })

        Yajl::Parser.new(symbolize_keys: true).parse(uri)[:data][:children].each do |entry|
          begin
            score = entry[:data][:score].to_i
            url   = URI.sanitize(entry[:data][:url]).meta.last_effective_uri
            title = entry[:data][:title]

            next unless score > 0
            unless update.execute(score, url, url).rows > 0
              Scheme::Link.create(title: title, url: url, native_score_reddit: score)
            end

            permalink = URI.sanitize('http://www.reddit.com/' + entry[:data][:permalink])
            unless update.execute(score, permalink, permalink).rows > 0
              Scheme::Link.create(title: title, url: permalink, native_score_reddit: score)
            end
          rescue => error
            warn error.message
          end
        end
      end
    end # NativeScoreReddit
  end # Job
end # Oursignal
