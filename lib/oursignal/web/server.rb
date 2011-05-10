require 'oursignal/web'

# Applications.
require 'oursignal/profiles'
require 'oursignal/signal'

module Oursignal
  class Web
    class Server < Web
      get('/about'){ haml :about}

      get '/css/screen.css' do
        content_type 'text/css', charset: 'utf-8'
        scss :screen
      end

      get %r{^/? $}x do
        redirect url(:signal), 301 # TODO: Internal redirect.
      end

      map '/profiles', Profiles
      map '/signal',   Signal
    end # Server
  end # Web
end # Oursignal
