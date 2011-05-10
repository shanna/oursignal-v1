require 'oursignal/web'

module Oursignal
  class Web
    class Server < Web
      get '/' do
        # TODO: The signal.
        haml :oursignal
      end

      get('/about'){ haml :about}

      get '/css/screen.css' do
        content_type 'text/css', charset: 'utf-8'
        scss :'css/screen'
      end
    end # Server
  end # Web
end # Oursignal
