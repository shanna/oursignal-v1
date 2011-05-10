require 'resque'

module Oursignal
  module Score
    class Native
      class << self
        def url
          raise NotImplementedError
        end

        def perform io
          raise NotImplementedError
        end

        def find klass
          all.find{|s| s.to_s.downcase == klass.to_s.downcase}
        end

        def all
          @@all ||= Set.new
        end

        def inherited klass
          self.all << klass
        end

        def read
          all.each{|source| Resque::Job.create :native_score_get, 'Oursignal::Job::NativeScoreGet', source}
        end
      end
    end # Native
  end # Score
end # Oursignal

# TODO: Fugly factory is fugly.
require 'oursignal/score/native/delicious'
require 'oursignal/score/native/reddit'
require 'oursignal/score/native/ycombinator'

