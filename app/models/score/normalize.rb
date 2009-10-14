require 'math/uniform_distribution'

class Score
  module Normalize
    def normalized
      ((score_normalizer.at(score).to_f + 1) / 100).round(2)
    end

    def score_normalizer
      Math::UniformDistribution.new('score_' + source) do
        total = ::Score.count(:source => source)
        last  = ::Score.first(:order => [:score.desc], :source => source).score
        (1 .. 100).to_a.map! do |range|
          offset = (total * (range.to_f / 100)).to_i
          score   = ::Score.first(:source => source, :order => [:score.asc], :offset => offset)
          score ? score.score : last
        end
      end
    end
  end # Normalize
end # Score

