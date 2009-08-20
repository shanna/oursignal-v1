require 'oursignal/score/source'
require 'json'

module Oursignal
  module Score
    class Source
      class Reddit < Source
        self.interval = 15.minutes

        def http_uri
          @http_uri ||= uri('http://www.reddit.com/.json').freeze
        end

        def work(data = '')
          JSON.parse(data)['data']['children'].each do |entry|
            score(entry['data']['url'], entry['data']['ups'].to_i)
          end
        end
      end # Reddit
    end # Source
  end # Score
end # Oursignal
