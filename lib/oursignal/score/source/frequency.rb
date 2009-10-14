require 'score/frequency'

module Oursignal
  module Score
    class Source
      class Frequency < Source
        def call
          Link.all.each do |link|
            link.extend ::Score::Frequency
            score(link.url, link.frequency_score)
          end
        end
      end # Frequency
    end # Source
  end # Score
end # Oursignal
