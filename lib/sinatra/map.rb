require 'sinatra/base'
require 'rack/utils'

module Sinatra
  class Base
    module Map
      def map path, klass
        path = map_compile path
        [:get, :put, :post, :delete, :head].each do |verb|
          send(verb, path) do
            # Keep the original request path handy.
            env['FORWARDED_REQUEST_PATH'] ||= env['REQUEST_PATH']

            env['QUERY_STRING'] = Rack::Utils.build_nested_query(params)
            env['PATH_INFO']    = env['REQUEST_PATH'] = env['REQUEST_PATH'].gsub(path, '')
            klass.call(env)
          end
        end
      end

      private
        # Only differs from Sinatra::Base.compile (my version) in that it acts as a catchall for stringy routes (no $).
        # https://github.com/shanna/sinatra/compare/master...named_capture_routing#L2R1057
        def map_compile path
          if path.respond_to? :to_str
            special_chars = %w{. + ( )}
            pattern       = path.to_str.gsub(/((:\w+)|[\*#{special_chars.join}])/) do |match|
              case match
                when '*'            then '(?<splat>.*?)'
                when *special_chars then Regexp.escape(match)
                else "(?<#{$2[1..-1]}>[^/?&#]+)"
               end
            end
            /^#{pattern}/
          elsif path.respond_to? :match
            path
          else
            raise TypeError, path
          end
        end
    end # Map

    extend Map
  end # Base
end # Sinatra
