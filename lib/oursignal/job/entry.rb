require 'nokogiri'
require 'uri/domain'
require 'uri/meta'
require 'uri/sanitize'

require 'oursignal/job'

# Business.
require 'oursignal/entry'

module Oursignal
  module Job

    #--
    # TODO: Modularize all this logic.
    class Entry
      extend Resque::Plugins::Lock
      @queue = :entry

      class << self
        def perform feed_url, xml
          feed = Oursignal::Feed.find(feed_url) || return
          doc  = Nokogiri::XML.parse(xml)       || return
          entry_el = doc.root
          entry_el.add_namespace_definition('atom', 'http://www.w3.org/2005/Atom')

          # Entry.
          entry_url = URI.sanitize(entry_el.at(%q{./atom:link[@rel='alternate'] | ./link}).text.strip)
          entry_url = entry_url.meta.last_effective_uri if entry_url.is_a?(URI::HTTP) # TODO: No HTTPS support in metauri yet?

          # Native score since we can.
          score_digg = 0
          if score_digg_el = entry_el.at_xpath('./digg:diggCount', {'digg' => 'http://digg.com/docs/diggrss/'})
            score_digg = score_digg_el.text.to_f rescue 0
          end

          # Links.
          URI::Meta.multi(parse(feed, entry_el)) do |meta|
            puts meta
            link_url = URI.sanitize(meta.last_effective_uri)
            if link = Oursignal::Link.find(link_url)
              link.update(score_digg: score_digg, updated_at: Time.now) if score_digg > 0
            else
              link = Oursignal::Link.create(
                title:      entry_el.at('./atom:title | ./title').text.strip,
                url:        link_url,
                score_digg: score_digg
              )
            end

            Oursignal::Entry.get(feed_id: feed.id, link_id: link.id) ||
              Oursignal::Entry.create(feed_id: feed.id, link_id: link.id, url: entry_url)
          end
        end

        protected
          # ==== Notes
          # Doesn't include the feed URL if external (to feed.domain) URLs exist.
          def parse feed, entry_el
            urls = []

            begin
              content = entry_el.at('./atom:content | ./atom:summary | ./description').text rescue ''
              Nokogiri::XML.parse("<r>#{content}</r>").xpath('//a').each do |anchor|
                url   = URI.sanitize(anchor.attribute('href').text) rescue next
                title = anchor.text.strip
                next unless title =~ /\w+/ && url.is_a?(URI::HTTP)
                next if URI.domain(feed.url) == URI.domain(url)
                urls << url
              end
            rescue Nokogiri::XML::SyntaxError
              warn(%Q{#{$!.message}:\n#{$!.backtrace.join("\n")}})
            end
            urls << URI.sanitize(entry_el.at(%q{./atom:link[@rel='alternate'] | ./link}).text.strip) if urls.empty?
            urls
          end
      end
    end # Entry
  end # Job
end # Oursignal
