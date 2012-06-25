require 'oursignal/scored_link'
require 'oursignal/timestep'
require 'oursignal/web'

module Oursignal
  class Web
    class Server < Web
      ETAG = Time.now.to_i

      get '/' do
        haml :oursignal
      end

      get '/timestep.json' do
        content_type :json
        @timestep = Timestep.find(params[:time] || Time.now) or raise Sinatra::NotFound

        etag @timestep.id
        @links    = ScoredLink.find @timestep.id
        Yajl.dump @links.to_a
      end

      get('/options') do
        expires 86_400
        etag ETAG
        haml :options
      end

      get('/about') do
        expires 86_400
        etag ETAG
        haml :about
      end

      get('/api') do
        expires 86_400
        etag ETAG
        haml :api
      end

      get '/css/screen.css' do
        expires 86_400
        etag ETAG
        content_type 'text/css', charset: 'utf-8'
        scss :'css/screen', style: :compact, line_comments: false
      end
    end # Server
  end # Web
end # Oursignal
