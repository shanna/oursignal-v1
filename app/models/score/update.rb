class Score
  module Update
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def sources
        # TODO: Move the source code into Score:: namespace.
        # Sources.subclasses
        %w{delicious digg frequency freshness reddit ycombinator}
      end
    end # ClassMethods
  end # Update
end # Score
