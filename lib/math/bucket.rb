module Math
  # A kind of uniform distribution I don't know the real name of.
  class Bucket
    def initialize buckets
      @buckets = buckets
    end

    def at value
      find = @buckets.find{|r| value <= r}
      find ? (@buckets.index(find).to_f / 100) : 1.0
    end
  end # Bucket
end # Math
