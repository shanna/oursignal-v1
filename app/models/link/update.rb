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

      begin
        self.score_average = (local_scores.map(&:normalized).inject(&:+) / local_scores.size)
        self.score_bonus   = local_scores.size >= 1 ? (Math.log(local_scores.size + 1) / Math.log(::Score.sources.size + 1)) : 0.0
        self.score         = score_average * score_bonus * age

        v = ::Velocity.new(last_link, self)
        self.velocity_average = v.velocity
        self.velocity         = v.normalized
      rescue => e
        DataMapper.logger.error("link\terror\n#{$!.message}\n#{$!.backtrace}")
      ensure
        self.score_at = DateTime.now
        self.save
      end
      [last_link, self]
    end
  end # Update
end # Link
