class Application < Merb::Controller
  before do
    unless params[:openid_url].blank?
      uri = Addressable::URI.heuristic_parse(params[:openid_url])
      params[:openid_url] = OpenID.normalize_url(uri.normalize)
    end
  end

  protected
    def ensure_authorized
      $stderr.puts session.user.username
      $stderr.puts params['username']
      raise Forbidden unless session.user.username == params['username']
    end
end
