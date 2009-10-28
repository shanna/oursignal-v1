class Exceptions < Merb::Controller
  provides :json
  before :purge_username_cookie

  def exception
    display messages
  end

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
      content_type
      request.exceptions.map(&:message)
    rescue NotAcceptable
      self.content_type = :html
    end
end
