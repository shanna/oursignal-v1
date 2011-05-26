require 'uri/sanitize'
require 'uri/meta'

require 'oursignal/link'

# TODO: Use memcache?
URI::Meta::Cache.cache = nil

module Oursignal
  module Job
    class NativeScore
      extend Resque::Plugins::Lock
      @queue = :native_score

      def self.perform source, url, score, title = nil
        url = URI.sanitize(url).meta
        url = url.last_effective_uri unless url.errors?

        update = Oursignal.db.prepare(%Q{
          update links
          set #{source} = ?
          where url in (
            select l.url
            from links l
            left join entries e on (e.link_id = l.id)
            where l.url = ? or e.url = ?
          )
        })

        if update.execute(score, url, url).rows == 0 && title
          Oursignal::Link.create(title: title, url: url, :"#{source}" => score)
        end
      end
    end # NativeScore
  end # Job
end # Oursignal
