require 'oursignal/job'

module Oursignal
  module Score
    class Source < Job
      self.poll_time = 5

      def poll
        links = Link.all(:conditions => {:score => nil})
        links + Link.all(:conditions => {:updated_at => {:'$lt' => Time.now - 60 * 15}})
      end

      def work(links)
        $stderr.puts 'SOURCE WORK ' + links.map(&:url).inspect
        links.each do |link|
          # scores = self.class.subclasses.each{|s| s.new.score}
          link.score = 0.5 # TODO: scores ...
          link.save
        end
      end
    end # Source
  end # Score
end # Oursignal
