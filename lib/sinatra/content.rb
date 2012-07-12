require 'sinatra/base'

module Sinatra
  class Base
    module Content
      def content name, &block
        @content ||= Hash.new{|h, k| h[k] = []}
        @content[name] << block if block
        @content[name]
      end

      def yield_content name, *args
        content(name).each do |block|
          haml_concat(capture_haml(*args, &block).strip) if block_is_haml?(block)
        end
      end

      def get_content name, *args
        capture_haml{ yield_content(name, *args) }
      end

      def has_content? name
        @content && @content.key?(name)
      end
    end

    helpers Content
  end # Base
end # Sinatra
