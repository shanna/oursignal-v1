require 'uri/sanitize'
require 'uri/meta'

require 'oursignal/scheme/link'

# TODO: Use memcache?
URI::Meta::Cache.cache = nil

module Oursignal
  module Job
    class NativeScore
      extend Resque::Plugins::Lock
      @queue = :native_score

      def self.perform source, url, score, title
        url = URI.sanitize(url).meta
        url = url.last_effective_uri unless url.errors?

        update = Oursignal.db.prepare(%Q{
          update links
          set #{source} = ?
          where url in (
            select l.url
            from links l
            left join entry_links el on (el.link_id = l.id)
            left join entries e on (e.id = el.entry_id)
            where l.url = ? or e.url = ?
          )
        })

        unless update.execute(score, url, url).rows > 0
          Scheme::Link.create(title: title, url: url, :"#{source}" => score)
        end
      end
    end # NativeScore
  end # Job
end # Oursignal
