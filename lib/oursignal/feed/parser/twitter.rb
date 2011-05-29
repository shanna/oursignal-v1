require 'resque'
require 'yajl'

require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Twitter < Native
        def self.url
          Oursignal.db.execute('select url from links').map do |link|
            %Q{http://urls.api.twitter.com/1/urls/count.json?url=#{URI.escape(link[:url])}}
          end
        end

        def self.perform source
          begin
            tweet = Yajl::Parser.new(symbolize_key: true).parse(source)
            Resque::Job.create :native_score, 'Oursignal::Job::NativeScore', 'score_twitter', tweet[:url], tweet[:count]
          rescue => error
            warn error.message
          end
        end
      end
    end # Native
  end # Score
end # Oursignal

