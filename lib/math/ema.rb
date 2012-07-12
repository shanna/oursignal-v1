module Math
  # Exponential Moving Average
  #
  #==== See
  # http://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average
  class Ema
    attr_reader :average, :decay

    #==== Parameters
    # decay<Float>::
    # A rate of decay (aka smoothness percentage) between (0 < range < 1). The closer to one the faster it discounts
    # older values.
    #
    # initial<Float>::
    # The initial value.
    def initialize decay, initial = 0.0
      @decay, @average = decay.to_f, initial.to_f
    end

    #==== Parameters
    # values<Float, Array<Float>>:: New value or array of new values in order (oldest to newest).
    #
    #==== Return
    # average<Float>:: The moving average after updates.
    def update values
      @average = [values].flatten.inject(@average){|a, v| a = a * @decay + (1 - @decay) * v}
    end
  end # Ema
end # Math

