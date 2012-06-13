require 'math/bucket'

# Schema.
require 'oursignal/scheme/score_bucket'

module Oursignal
  class ScoreBucket < Scheme::ScoreBucket
    def self.find source
      execute(%q{select * from score_buckets where source = ?}, source.to_s).first
    end

    def at value
      (@buckets ||= Math::Bucket.new(buckets)).at(value)
    end
  end # Feed
end # Oursignal


