require File.join(File.dirname(__FILE__), '..', 'oursignal')

require 'haml'
require 'sinatra/base'

# TODO: I'm not sure how you are supposed to set the external encoding.
# It's UTF-8 already on OSX.
Encoding.default_internal = Encoding.default_external = "UTF-8"

module Oursignal
  class Web < Sinatra::Base
    set :root, Fundry.root
    set :haml, escape_html: true

    disable :raise_errors, :show_exceptions, :dump_errors
    enable  :sessions, :methodoverride
    enable  :static, :logging, :dump_errors if development?

    error Sinatra::NotFound do
      haml :not_found
    end
  end # Web
end # Oursignal

