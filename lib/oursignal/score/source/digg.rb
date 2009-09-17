require 'oursignal/score/source'
require 'digg'

module Oursignal
  module Score
    class Source
      class Digg < Source
        def call
          rss = ::Digg.read
          ns  = {'digg' => 'http://digg.com/docs/diggrss/'}
          rss.xpath('//item').each do |item|
            begin
              real_url = URI.sanatize(item.at('./digg:source', ns).text)
              digg_url = URI.sanatize(item.at('./link').text)
              diggs    = item.at('./digg:diggCount', ns).text.to_i
            rescue
              next
            end

            # Fake a meta entry and force a meta update to fix digg RSS feed links as metauri.com doesn't
            # (and shouldn't) follow links from these sites.
            # TODO: I should build something more general on top of URI::Meta to remove all these known aggregator sites?
            meta = URI::Meta.new(:uri => digg_url, :last_effective_uri => real_url)
            URI::Meta::Cache.store(digg_url, meta)
            Link.repository.adapter.execute(%q{update links set meta_at = null where url = ?}, digg_url)

            score(real_url, diggs)
            score(digg_url, diggs)
          end
        end
      end # Digg
    end # Source
  end # Score
end # Oursignal
