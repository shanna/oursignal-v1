require 'resque'
require 'yajl'

require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Reddit < Native
        def self.url
          @url ||= 'http://www.reddit.com/.json'.freeze
        end

        def self.perform source
          Yajl::Parser.new(symbolize_keys: true).parse(source)[:data][:children].each do |entry|
            begin
              score     = entry[:data][:score].to_i || next
              url       = entry[:data][:url]        || next
              title     = entry[:data][:title]
              permalink = 'http://www.reddit.com/' + entry[:data][:permalink]

              Resque::Job.create :native_score, 'Oursignal::Job::NativeScore', 'score_reddit', url, score, title
              Resque::Job.create :native_score, 'Oursignal::Job::NativeScore', 'score_reddit', permalink, score, title
            rescue => error
              warn error.message
            end
          end
        end
      end # Reddit
    end # Native
  end # Score
end # Oursignal

