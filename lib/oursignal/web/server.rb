require 'oj'

require 'oursignal/scored_link'
require 'oursignal/timestep'
require 'oursignal/web'
require 'json' # Monkey patches DateTime and company for mode: :compat in Oj.

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
        Oj.dump @links.to_a, mode: :compat
      end

      get('/about'){ haml :about}

      get '/css/screen.css' do
        content_type 'text/css', charset: 'utf-8'
        scss :'css/screen', style: :compact, line_comments: false
      end
    end # Server
  end # Web
end # Oursignal
