require 'oursignal/web'

module Oursignal
  class Web
    class Server < Web
      get('/about'){ haml :about}

      get '/css/screen.css' do
        content_type 'text/css', charset: 'utf-8'
        scss :screen
      end

      get '/' do
        haml :signal
      end
    end # Server
  end # Web
end # Oursignal
