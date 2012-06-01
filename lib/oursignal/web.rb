require File.join(File.dirname(__FILE__), '..', 'oursignal')
require 'compass'
require 'haml'
require 'sass'
require 'sinatra/base'
require 'yajl'

# Helpers.
require 'sinatra/content'
require 'sinatra/page'
require 'sinatra/url'

module Oursignal
  class Web < Sinatra::Base
    configure do
      Compass.configuration do |config|
        config.project_path = Oursignal.root
        config.sass_dir     = 'views/css'
      end
    end


    set :root, Oursignal.root
    set :haml, escape_html: true, format: :html5
    set :scss, Compass.sass_engine_options

    disable :protection # fu rack-protection, you hate being run through an nginx proxy.
    disable :raise_errors, :show_exceptions, :dump_errors
    enable  :sessions, :methodoverride
    enable  :static, :logging, :dump_errors if development?

    error Sinatra::NotFound do
      haml :not_found
    end
  end # Web
end # Oursignal

