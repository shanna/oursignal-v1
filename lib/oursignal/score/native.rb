require 'resque'
require 'yajl'

module Oursignal
  module Score
    class Native
      attr_reader :link

      def initialize link
        @link = link
      end

      def parse source
        raise NotImplementedError
      end

      def url
        raise NotImplementedError
      end

      class << self
        def find klass
          all.find{|s| s.to_s.downcase == klass.to_s.downcase}
        end

        def all
          @@all ||= Set.new
        end

        def inherited klass
          self.all << klass
        end

        def read *links
          links = execute(%q{
            select * from links
            where updated_at < now() - interval '5 minutes'
          }) if links.empty?
          links.each do |link|
            all.each do |source|
              Resque::Job.create :native_score_get 'Oursignal::Job::NativeScoreGet', source, link.id
            end
          end
        end
      end
    end # Native
  end # Score
end # Oursignal

# TODO: Fugly factory is fugly.
require 'oursignal/score/native/delicious'
require 'orusignal/score/native/digg'
require 'oursignal/score/native/facebook'
require 'oursignal/score/native/googlebuzz'
# require 'oursignal/score/native/reddit'
require 'oursignal/score/native/twitter'
# require 'oursignal/score/native/ycombinator'

