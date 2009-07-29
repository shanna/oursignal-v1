class Application < Merb::Controller
  before do
    unless params[:openid_url].blank?
      uri = Addressable::URI.heuristic_parse(params[:openid_url])
      params[:openid_url] = OpenID.normalize_url(uri.normalize)
    end
  end

  protected
    def user
      if params[:username] && !(session.user && params[:username] == session.user.username)
        final = User.first(:conditions => {:username => params[:username]})
      end
      final || session.user || default_user
    end

    def default_user
      @default_user ||= User.first(:conditions => {:username => 'oursignal'})
    end

    def ensure_authorized
      raise Forbidden unless session.user.username == params[:username]
    end
end
