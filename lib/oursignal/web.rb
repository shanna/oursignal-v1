require File.join(File.dirname(__FILE__), '..', 'oursignal')
require 'haml'
require 'sinatra/base'
require 'sinatra/content'
require 'sinatra/page'
require 'sinatra/url'
require 'sinatra-auth'

# TODO: I'm not sure how you are supposed to set the external encoding.
# It's UTF-8 already on OSX.
Encoding.default_internal = Encoding.default_external = "UTF-8"

module Oursignal
  class Web < Sinatra::Base
    register Sinatra::Authentication

    set :root, Oursignal.root
    set :haml, escape_html: true, format: :html5
    set :scss, style: :compact

    disable :raise_errors, :show_exceptions, :dump_errors
    enable  :sessions, :methodoverride
    enable  :static, :logging, :dump_errors if development?

    authenticate do
      Oursignal::Profile.authenticate(*params.values_at(:identifier, :password))
    end

    # Odds and ends.
    get('/about'){ haml :about }
    get('/developers'){ haml :developers }

    # Default username. Yes it's a dupe, suck it up google.
    get %r{^/? $}x do
      redirect url(:users, :oursignal)
    end

    # Friendly username.
    get %r{^/ (?<username>[a-zA-Z]\w+) (?<format>\.(?:html|rss|json|jsonp))? /? $}x do |username, format|
      # TODO: Internal redirect?
      redirect url(:users, username, format)
    end

    get '/css/screen.css' do
      scss :'css/screen'
    end

    error Sinatra::NotAuthenticated do
      haml :not_authenticated
    end

    error Sinatra::NotAuthorized do
      haml :not_authorized
    end

    error Sinatra::NotFound do
      haml :not_found
    end
  end # Web
end # Oursignal

