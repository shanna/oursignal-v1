require 'bigdecimal'

class Float
  def round(to = 0)
    rounded = BigDecimal(self.to_s).round(to)
    to == 0 ? rounded.to_i : rounded
  end
end

