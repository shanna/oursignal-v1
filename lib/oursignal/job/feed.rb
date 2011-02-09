require 'nokogiri'
require 'oursignal/feed'
require 'oursignal/job'

module Oursignal
  module Job
    #--
    # TODO: Stream the feed file in.
    class Feed
      extend Resque::Plugins::Lock
      @queue = :feed

      class << self
        #--
        # TODO: First or create the feed?
        def perform url, path
          feed = Oursignal::Feed.search(url)          || return
          doc  = Nokogiri::XML.parse(File.open(path)) || return
          root = doc.root
          root.add_namespace_definition('atom', 'http://www.w3.org/2005/Atom')

          ns = doc.collect_namespaces
          root.xpath(%q{//atom:feed | //rss[@version='2.0']/channel}).each do |feed_el|
            feed.update(
              title:      feed_el.at('./atom:title | ./title').text.strip,
              site:       URI.sanitize(feed_el.at(%q{./atom:link[@rel='alternate'] | ./link}).text.strip),
              updated_at: Time.now
            )

            feed_el.xpath('//atom:entry | //item').each do |entry_el|
              ns.each{|prefix, uri| entry_el.add_namespace_definition(prefix, uri)}
              Resque::Job.create :entry, 'Oursignal::Job::Entry', url, entry_el.to_xml
            end
          end
          # XXX: Don't unlink feeds for now.
          # File.unlink(path)
        end
      end
    end # Feed
  end # Job
end # Oursignal
