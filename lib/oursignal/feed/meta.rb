require 'oursignal/job'

module Oursignal
  module Feed

    # Update link meta info.
    class Meta < Job
      def call
        ::Link::Meta.update
      end
    end # Meta
  end # Feed
end # Oursignal

