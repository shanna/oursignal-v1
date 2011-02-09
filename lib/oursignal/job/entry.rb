require 'nokogiri'
require 'uri/domain'
require 'uri/meta'
require 'uri/sanitize'

require 'oursignal/job'
require 'oursignal/feed'

# TODO: Business.
require 'oursignal/scheme/entry'
require 'oursignal/scheme/entry_link'
require 'oursignal/scheme/link'

module Oursignal
  module Job

    #--
    # TODO: Modularize all this logic.
    class Entry
      extend Resque::Plugins::Lock
      @queue = :entry

      class << self
        def perform feed_url, xml
          feed = Oursignal::Feed.search(feed_url) || return
          doc  = Nokogiri::XML.parse(xml)         || return
          entry_el = doc.root
          entry_el.add_namespace_definition('atom', 'http://www.w3.org/2005/Atom')

          # Entry.
          entry_url = URI.sanitize(entry_el.at(%q{./atom:link[@rel='alternate'] | ./link}).text.strip)
          entry_url = entry_url.meta.last_effective_uri if entry_url.is_a?(URI::HTTP) # TODO: No HTTPS support in metauri yet?
          entry     = Scheme::Entry.first('url = ?', entry_url) || Scheme::Entry.create(feed_id: feed.id, url: entry_url).first

          # Native scores if we can.
          # TODO: Reddit comment count is in the content?
          score_digg = 0
          if score_digg_el = entry_el.at('./digg:diggCount', {'digg' => 'http://digg.com/docs/diggrss/'})
            score_digg = score_digg_el.text.to_f rescue 0
          end

          # Links.
          URI::Meta.multi(parse(feed, entry_el)) do |meta|
            link_url = URI.sanitize(meta.last_effective_uri)
            if link = Scheme::Link.first('url = ?', link_url)
              link.update(native_score_digg: score_digg, updated_at: Time.now) if score_digg > 0
            else
              Scheme::Link.create(
                title:             entry_el.at('./atom:title | ./title').text.strip,
                url:               link_url,
                native_score_digg: score_digg
              ).first
            end

            Scheme::EntryLink.get(entry_id: entry.id, link_id: link.id) ||
              Scheme::EntryLink.create(entry_id: entry.id, link_id: link.id)
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
            urls.select{|url| url.is_a?(URI::HTTP)}
          end
      end
    end # Entry
  end # Job
end # Oursignal
