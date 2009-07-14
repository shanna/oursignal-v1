require 'oursignal/job'

module Oursignal
  module Score
    class Tally < Job
      self.poll_time = 5

      def poll
        # These should be exclusive unless soemthing has gone wrong.
        links = Link.all(:conditions => {:score => nil})
        links + Link.all(:conditions => {:updated_at => {:'$lt' => Time.now - 60 * 15}})

        Merb.logger.info("#{self.class}: Tally for #{links.size} links.") unless links.empty?
        links
      end

      def work(links)
        links.each do |link|
          if scores = ::Score.all(:conditions => {:url => link.url})
            score = scores.map(&:score).inject(0){|acc, score| acc += score}
            link.velocity = score - (link.score || 0)
            link.score    = score
            link.save
          end
        end
      end
    end # Tally
  end # Score
end # Oursignal

