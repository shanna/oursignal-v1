require 'math/uniform_distribution'

class Score
  module Freshness
    def freshness_score
      hours = (Time.now - referred_at.to_time).to_f / 1.hour
      hours < 24 ? ((24.to_f - hours) / 24) : 0.to_f
    end
  end # Freshness
end # Score


