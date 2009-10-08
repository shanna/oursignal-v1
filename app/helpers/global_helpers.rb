module Merb
  module GlobalHelpers

    def title
      @title ||= 'oursignal'
      [@title].flatten.join(' &raquo; ')
    end

    def classes
      [params[:controller], params.values_at(:controller, :action).join('_')].join(' ').gsub('/', '_')
    end

    def messages_for(errors)
      if errors.respond_to?(:errors)
        error_messages_for errors, :header => ''
      elsif errors.is_a?(Hash)
        [:error, :success, :notice].map{|type| tag(:div, :class => type){message[type]}}
      end
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
