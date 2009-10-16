require 'score/freshness'

module Oursignal
  module Score
    class Source
      class Freshness < Source
        def call
          Link.all.each do |link|
            link.extend ::Score::Freshness
            score(link.url, link.freshness_score)
          end
        end
      end # Freshness
    end # Source
  end # Score
end # Oursignal

