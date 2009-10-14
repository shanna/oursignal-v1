require 'math/uniform_distribution'

class Score
  module Frequency
    def frequency_score
      average_daily_links = feeds.inject(0.0){|ac, feed| ac += feed.daily_links; ac} / feeds.size
      1 - frequency_normal(average_daily_links)
    end

    def frequency_normal(frequency)
      (frequency_distribution.at(frequency).to_f * (1.to_f / 100)).round(2)
    end

    def frequency_distribution
      Math::UniformDistribution.new(:frequency) do
        total = ::Feed.count
        last  = ::Feed.first(:order => [:daily_links.desc]).daily_links
        (1 .. 100).to_a.map! do |range|
          offset = (total * (range.to_f / 100)).to_i
          feed   = ::Feed.first(:order => [:daily_links.asc], :offset => offset)
          feed ? feed.daily_links : last
        end
      end
    end
  end # Frequency
end # Score

