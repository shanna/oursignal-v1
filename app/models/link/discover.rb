require 'uri/sanatize'
require 'uri/domain'
require 'score/frequency'

class Link
  module Discover
    def self.included(klass)
      klass.extend ClassMethods
      super
    end

    module ClassMethods
      def discover(feed, entry)
        entry_url = URI.sanatize(entry.url) rescue return
        return if feed.feed_links.first(:url => entry_url)

        discover_entry_urls(feed, entry).each do |url|
          title            = entry.title.strip.to_utf8 || next
          link             = first_or_new({:url => url}, :title => title)
          # TODO: Only adding the new ref to the hash would be faster if I trusted the cache not to get out of sync.
          link.referrers   = link.feed_links.map{|fl| [fl.feed.domain, fl.url]}.to_mash
          link.referred_at = DateTime.now if link.referred_at.blank?

          # TODO: Clean up this hack job.
          link.extend ::Score::Frequency
          ::Score.create(:url => url, :score => link.frequency_score, :source => 'frequency') if link.new?

          link.save && feed.feed_links.first_or_create({:link => link}, :url => entry_url)
        end
      end

      protected

        # ==== Notes
        # Doesn't include the feed URL if external (to feed.domain) URLs exist.
        def discover_entry_urls(feed, entry)
          urls = []

          begin
            Nokogiri::XML.parse("<r>#{entry.summary}</r>").xpath('//a').each do |anchor|
              url   = URI.parse(URI.sanatize(anchor.attribute('href').text)) rescue next
              title = anchor.text.strip
              next unless title =~ /\w+/ && url.is_a?(URI::HTTP)
              next if feed.domain == url.domain
              urls << url.to_s
            end
          rescue Nokogiri::XML::SyntaxError
          rescue
            DataMapper.logger.error("link\terror\n#{$!.message}\n#{$!.backtrace}")
          end

          urls = [entry.url] if urls.empty?
          urls
        end
    end # ClassMethods
  end # Discover
end # Link

