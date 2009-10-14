require 'oursignal/job'

module Oursignal
  module Score
    class Update < Job

      def call
        # TODO: I can build an 'OR' with DM::Query even if the class finders can't do it yet.
        links =  Link.all(:score_at.lt => (Time.now - 5.minutes).to_datetime)
        links += Link.all(:score_at => nil)
        unless links.empty?
          links.each do |link|
            summary = link.selfupdate
            require 'pp'
            pp summary
          end
        end
      end

    end # Update
  end # Score
end # Oursignal

