require 'score/freshness'
require 'score/frequency'

module Oursignal
  module Score
    class Source
      class Freshness < Source
        def call
          Link.send(:include, ::Score::Freshness)
          Link.send(:include, ::Score::Frequency)
          Link.all.each do |link|
            score('frequency', link.url, link.frequency_score)
            score('freshness', link.url, link.freshness_score)
          end
        end
      end # Freshness
    end # Source
  end # Score
end # Oursignal

