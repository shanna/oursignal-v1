require 'nokogiri'
require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Delicious < Native
        def self.url
          @url ||= 'http://delicious.com/popular/'.freeze
        end

        def self.perform source
          Nokogiri::HTML.parse(source).css('.data').each do |entry|
            begin
              score  = entry.at_css('.delNavCount').text.strip.to_i || next
              link   = entry.at_css('.taggedlink')                  || next
              title  = link.text.strip
              url    = link.attribute('href')

              Resque::Job.create :native_score, 'Oursignal::Job::NativeScore', 'score_delicious', url, score, title
            rescue => error
              warn error.message
            end
          end
        end
      end # Delicious
    end # Native
  end # Score
end # Oursignal

