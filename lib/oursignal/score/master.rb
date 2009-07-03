module Oursignal
  module Score

    class Master
      def self.run
        Signal.trap('INT'){ puts '' && EM.stop}
        EM.run{ Source.sources.each(&:run)}
      end
    end # Master
  end # Score
end # Oursignal
