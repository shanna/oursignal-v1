require 'oursignal/scored_link'
require 'oursignal/timestep'
require 'oursignal/web'

module Oursignal
  class Web
    class Server < Web
      LAST_MODIFIED = Time.now

      get '/' do
        expires 86_400
        last_modified LAST_MODIFIED
        haml :oursignal
      end

      get '/timestep.json' do
        content_type :json

        if params[:time]
          @timestep = Timestep.find(params[:time]) or raise Sinatra::NotFound
        else
          @timestep = Timestep.now or raise Sinatra::NotFound
        end

        etag @timestep.id
        @links    = ScoredLink.find @timestep.id
        Yajl.dump @links.to_a
      end

      get('/options') do
        expires 86_400
        last_modified LAST_MODIFIED
        haml :options
      end

      get('/about') do
        expires 86_400
        last_modified LAST_MODIFIED
        haml :about
      end

      get('/api') do
        expires 86_400
        last_modified LAST_MODIFIED
        haml :api
      end

      get '/css/screen.css' do
        expires 86_400
        last_modified LAST_MODIFIED
        content_type 'text/css', charset: 'utf-8'
        scss :'css/screen', style: :compact, line_comments: false
      end
    end # Server
  end # Web
end # Oursignal
