require 'math/average/exponential_moving'
require 'velocity/normalize'

class Velocity
  include Velocity::Normalize

  attr_accessor :velocity

  def initialize(last_link, link)
    ema           = Math::Average::ExponentialMoving.new(0.9, (last_link.velocity_average || 0))
    self.velocity = ema.update(link.score - (last_link.score || 0))
  end
end
