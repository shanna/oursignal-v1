require 'nokogiri'
require 'resque'

require 'oursignal/score/native'

module Oursignal
  module Score
    class Native
      class Ycombinator < Native
        def self.url
          @url ||= 'http://news.ycombinator.com/'.freeze
        end

        def self.perform source
          Nokogiri::HTML.parse(source).css('td.title a').each do |entry|
            begin
              score = entry.xpath('../../following-sibling::tr[1]/td/span').text.to_i || next
              title = entry.text
              url   = entry.attribute('href').text
              url   = 'http://news.ycombinator.com/' + url unless url =~ %r{://}

              Resque::Job.create :native_score, 'Oursignal::Job::NativeScore', 'native_score_ycombinator', url, score, title
            rescue => error
              warn error.message
            end
          end
        end
      end # Ycombinator
    end # Native
  end # Score
end # Oursignal


