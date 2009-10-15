require 'uri/sanatize'
require 'uri/meta'

class Feed
  module Discover
    def self.included(klass)
      klass.extend ClassMethods
      super
    end

    module ClassMethods
      def discover(url)
        url  = URI.sanatize(url.to_s)

        # TODO: Better reporting.
        begin
          meta = URI::Meta.get(URI.parse(url), :timeout => 5)
          url  = (meta.feed || meta.last_effective_uri) if meta
        rescue => e
        rescue NotImplementedError => e
        end

        feed = first_or_new(:url => url.to_s)
        feed.save if feed.valid?(:discover) && feed.new?
        feed
      end
    end # ClassMethods
  end # Discover
end # Feed
