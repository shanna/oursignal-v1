require 'nokogiri'
require 'oursignal/job'
require 'uri/io'

require 'oursignal/scheme/link'

module Oursignal
  module Job
    class NativeScoreDelicious
      USER_AGENT = 'oursignal/0.2 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :native_score_delicious

      def self.perform
        uri = URI::IO.open('http://delicious.com/popular/') do |io|
          io.follow_location = true
          io.timeout         = 10
        end

        update = Oursignal.db.prepare(%q{
          update links
          set native_score_delicious = ?
          where url in (
            select l.url
            from links l
            left join entry_links el on (el.link_id = l.id)
            left join entries e on (e.id = el.entry_id)
            where l.url = ? or e.url = ?
          )
        })

        Nokogiri::HTML.parse(uri).css('.data').each do |entry|
          begin
            score  = entry.at_css('.delNavCount').text.strip.to_i
            link   = entry.at_css('.taggedlink')
            title  = link.text
            url    = URI.sanitize(link.attribute('href').to_s).meta.last_effective_uri

            next unless score > 0
            unless update.execute(score, url, url).rows > 0
              Scheme::Link.create(title: title, url: url, native_score_delicious: score)
            end
          rescue => error
            warn error.message
          end
        end
      end
    end # NativeScoreDelicious
  end # Job
end # Oursignal
