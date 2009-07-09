module Oursignal
  module Feed

    class Update
      include EM::Deferrable

      def self.run
        update = new
        update.callback{ EM.add_timer(30, method(:run))}
        Thread.new do
          begin
            Link.all(:conditions => {
              :updated_at => {:'$lt' => Time.now - 60 * 30},
              :feed       => {:'$ne' => nil}
            }).each(&:selfupdate)
          rescue => error
            Merb.logger.error("#{self}: Error #{error.message}")
          ensure
            update.succeed
          end
        end
      end
    end # Update
  end # Feed
end # Oursignal

