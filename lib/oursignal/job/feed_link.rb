require 'nokogiri'
require 'uri/domain'
require 'uri/meta'
require 'uri/sanitize'

require 'oursignal/job'
require 'oursignal/feed'

# TODO:
require 'oursignal/scheme/feed_link'

module Oursignal
  module Job

    #--
    # TODO: Modularize all this logic.
    class FeedLink
      extend Resque::Plugins::Lock
      @queue = :feed_link

      def self.perform feed_url, entry
        feed = Oursignal::Feed.search(feed_url) or return

        # TODO: Cleanup
        # TODO: Avoid metauri lookups for entries already in feed_links.
        URI::Meta.multi(parse(feed, entry)) do |meta|
          uri                = URI.sanitize(meta.uri.to_s)
          last_effective_uri = URI.sanitize(meta.last_effective_uri.to_s)
          next if Oursignal::Scheme::FeedLink.first('feed_id = ? and url = ?', feed.id, uri)

          # TODO: Referrers update.
          if link = Oursignal::Scheme::Link.first('url = ?', last_effective_uri)
            link.update(referred_at: Time.now)
          else
            link = Oursignal::Scheme::Link.create(title: entry['title'], url: last_effective_uri, referred_at: Time.now).first
            Oursignal::Scheme::FeedLink.create(feed_id: feed.id, link_id: link.id, url: uri)
          end
        end
      end

      protected
        # ==== Notes
        # Doesn't include the feed URL if external (to feed.domain) URLs exist.
        def self.parse(feed, entry)
          urls = []

          begin
            Nokogiri::XML.parse("<r>#{entry['content']}</r>").xpath('//a').each do |anchor|
              url   = URI.sanitize(anchor.attribute('href').text) rescue next
              title = anchor.text.strip
              next unless title =~ /\w+/ && url.is_a?(URI::HTTP)
              next if URI.domain(feed.url) == URI.domain(url)
              urls << url.to_s
            end
          rescue Nokogiri::XML::SyntaxError
          rescue
            warn(%Q{#{$!.message}:\n#{$!.backtrace.join("\n")}})
          end

          urls = [URI.sanitize(entry['url'])] if urls.empty?
          urls
        end
    end # FeedLink
  end # Job
end # Oursignal

