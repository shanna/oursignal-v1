class Exceptions < Merb::Controller
  provides :json
  before :purge_username_cookie

  def forbidden
    display messages
  end

  def bad_request
    display messages
  end

  def not_found
    display messages
  end

  def not_acceptable
    display messages
  end

  def unauthenticated
    display messages
  end

  protected
    def purge_username_cookie
      if !session.user || cookies[:username] != session.user.username
        cookies.delete(:username)
      end
    end

    def messages
      request.exceptions.map(&:message)
    end
end
