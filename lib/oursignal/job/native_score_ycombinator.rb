require 'nokogiri'
require 'oursignal/job'
require 'uri/io'

require 'oursignal/scheme/link'

module Oursignal
  module Job
    class NativeScoreYcombinator
      USER_AGENT = 'oursignal/0.2 +oursignal.com'

      extend Resque::Plugins::Lock
      @queue = :native_score_ycombinator

      def self.perform
        uri = URI::IO.open('http://news.ycombinator.com/') do |io|
          io.follow_location = true
          io.timeout         = 10
        end

        update = Oursignal.db.prepare(%q{
          update links
          set native_score_ycombinator = ?
          where url in (
            select l.url
            from links l
            left join entry_links el on (el.link_id = l.id)
            left join entries e on (e.id = el.entry_id)
            where l.url = ? or e.url = ?
          )
        })

        Nokogiri::HTML.parse(uri).css('td.title a').each do |entry|
          begin
            score = entry.xpath('../../following-sibling::tr[1]/td/span').text.to_i
            title = entry.text
            url   = entry.attribute('href').text
            url   = 'http://news.ycombinator.com/' + url unless url =~ %r{://}
            url   = URI.sanitize(url).meta.last_effective_uri

            next unless score > 0
            unless update.execute(score, url, url).rows > 0
              Scheme::Link.create(title: title, url: url, native_score_ycombinator: score)
            end
          rescue => error
            warn error.message
          end
        end
      end
    end # NativeScoreYcombinator
  end # Job
end # Oursignal
