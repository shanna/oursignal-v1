module Oursignal
  module Feed

    class Master
      def self.run
        Signal.trap('INT'){ puts '' && EM.stop}
        EM.run{ Oursignal::Feed::Update.run}
      end
    end # Master
  end # Feed
end # Oursignal

