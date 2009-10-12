require 'oursignal/score/source'
require 'math/uniform_distribution'

module Oursignal
  module Score
    class Source
      class Frequency < Source
        module UniformDistribution
          FREQUENCY_PRECISION = 100

          def frequency_score
            average_daily_links = feeds.inject(0.0){|ac, feed| ac += feed.daily_links; ac} / feeds.size
            1 - frequency_normal(average_daily_links)
          end

          def frequency_normal(frequency)
            (frequency_distribution.at(frequency).to_f * (1.to_f / FREQUENCY_PRECISION)).round(2)
          end

          def frequency_distribution
            Math::UniformDistribution.new(:frequency) do
              total = ::Feed.count(:total_links.gt => 0)
              last  = ::Feed.first(:order => [:daily_links.desc]).daily_links
              (1 .. FREQUENCY_PRECISION).to_a.map! do |range|
                offset = (total * (range.to_f / FREQUENCY_PRECISION)).to_i
                link   = ::Feed.first(:order => [:daily_links.asc], :offset => offset)
                link ? link.daily_links : last
              end
            end
          end
        end # UniformDistribution

        def call
          Link.all.each do |link|
            score(link.url, link.frequency_score)
          end
        end
      end # Frequency
    end # Source
  end # Score
end # Oursignal
