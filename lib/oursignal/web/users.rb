require 'oursignal/web'

module Oursignal
  class Web
    class Users < Web
      get %r{^/? (?<username>[a-zA-Z]\w+)? }x do |username|
        haml :'users/show'
      end
    end # Users
  end # Web
end # Oursignal

