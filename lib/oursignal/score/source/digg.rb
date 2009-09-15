require 'oursignal/score/source'
require 'nokogiri'

module Oursignal
  module Score
    class Source
      class Digg < Source
        def http_uri
          @http_uri ||= uri('http://services.digg.com/stories/popular',
            'appkey' => 'http://oursignal.com/',
            'type'   => 'xml'
          ).freeze
        end

        def work(data = '')
          Nokogiri::XML.parse(data).xpath('//story').each do |story|
            real_url = URI.sanatize(story.at('./@link').text)
            digg_url = URI.sanatize(story.at('./@href').text)

            # Fake a meta entry and force a meta update to fix digg RSS feed links as metauri.com doesn't
            # (and shouldn't) follow links from these sites.
            # TODO: I should build something more general on top of URI::Meta to remove all these known aggregator sites?
            meta = URI::Meta.new(:uri => digg_url, :last_effective_uri => real_url)
            URI::Meta::Cache.store(digg_url, meta)
            Link.repository.adapter.execute(%q{update links set meta_at = null where url = ?}, digg_url)

            score(digg_url, story.at('./@diggs').text.to_i)
            score(real_url, story.at('./@diggs').text.to_i)
          end
        end
      end # Digg
    end # Source
  end # Score
end # Oursignal
