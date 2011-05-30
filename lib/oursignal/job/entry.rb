require 'uri/sanitize'

# Business.
require 'oursignal/entry'
require 'oursignal/link'

module Oursignal
  module Job
    class Entry
      extend Resque::Plugins::Lock
      @queue = :entry

      def self.perform feed_id, entry_url, url, source, score, title
        entry_url = URI.sanitize(entry_url)
        url       = URI.sanitize(url)

        Oursignal.db.transaction :entry do
          if link = Oursignal::Link.find(url)
            link.update("#{source}" => score, updated_at: Time.now, referred_at: Time.now)
          else
            link = Oursignal::Link.create(title: title, url: url, :"#{source}" => score)
          end

          Oursignal::Entry.execute('select * from entries where feed_id = ? and url = ?', feed_id, entry_url).first ||
            Oursignal::Entry.create(feed_id: feed_id, link_id: link.id, url: entry_url)
        end
      end
    end # Entry
  end # Job
end # Oursignal
