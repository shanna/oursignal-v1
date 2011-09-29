require 'yajl'

require 'oursignal/scored_link'
require 'oursignal/timestep'
require 'oursignal/web'

module Oursignal
  class Web
    class Server < Web
      get '/' do
        haml :oursignal
      end

      get '/timestep.json' do
        content_type :json
        @timestep = Timestep.find(params[:time] || Time.now) or raise Sinatra::NotFound
        @links    = ScoredLink.find @timestep.id
        Yajl::Encoder.encode @links.to_a
      end

      get('/about'){ haml :about}

      get '/css/screen.css' do
        content_type 'text/css', charset: 'utf-8'
        scss :'css/screen'
      end
    end # Server
  end # Web
end # Oursignal
