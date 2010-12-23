require 'oursignal/web'

module Oursignal
  class Web
    class Users < Web
      get %r{^/? (?<username>[a-zA-Z]\w+)? /? }x do |username|
        haml :'users/show'
      end

      get '/new' do
        haml :'users/new'
      end

      post '/?' do
        Oursignal::Profile.create params[:user]
      end

      get %r{^/ (?<username>[a-zA-Z]\w+)? /edit }x do |username|
        authorize_user! username
      end

      put %r{^/ (?<username>[a-zA-Z]\w+)? /? }x do |username|
        authorize_user! username
        Oursignal::Profile.update @user, params[:user]
        # redirect
      end

      protected
        def authorized_user! identifier
          @user = Oursignal::Profile.search(identifier) or raise Sinatra::NotAuthorized
          authorize! @user.id
        end
    end # Users
  end # Web
end # Oursignal

