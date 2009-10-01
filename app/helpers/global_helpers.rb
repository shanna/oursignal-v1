module Merb
  module GlobalHelpers

    def title
      @title ||= 'oursignal'
      [@title].flatten.join(' &raquo; ')
    end

    def messages_for(errors)
      error_messages_for errors, :header => ''
    end

    def user
      if params[:username] && !(session.user && params[:username] == session.user.username)
        final = User.first(:conditions => {:username => params[:username]})
      end
      final || session.user || default_user
    end

    def default_user
      @default_user ||= User.first(:conditions => {:username => 'oursignal'})
    end
  end
end
