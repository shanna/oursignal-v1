require 'math/average/exponential_moving'

class Link
  module Update
    def scores
      ::Score.all(:url => url)
    end

    def age
      hours = (Time.now - referred_at.to_time).to_f / 1.hour
      hours < 24 ? ((24.to_f - hours) / 24) : 0.to_f
    end

    def selfupdate
      last_link    = self.copy
      local_scores = scores
      return [last_link, self] if local_scores.empty?

      begin
        self.score_average = local_scores.map(&:normalized).inject(&:+) / local_scores.size
        self.score_bonus   = local_scores.size.to_f / ::Score.sources.size
        self.score         = score_average * (0.1 * score_bonus + 0.9) * age

        ema = Math::Average::ExponentialMoving.new(0.5, (last_link.velocity_average || 0))
        self.velocity_average = ema.update(score - (last_link.score || 0))
        self.velocity         = Velocity.normalized(velocity_average)
      rescue => error
        DataMapper.logger.error(%Q{#{error.message}:\n#{error.backtrace.join("\n")}})
      ensure
        self.score_at = DateTime.now
        self.save
      end
      [last_link, self]
    end
  end # Update
end # Link
