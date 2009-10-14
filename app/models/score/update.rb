class Score
  module Update
    def included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def sources
        Sources.subclasses
      end
    end # ClassMethods

  end # Update
end # Score
