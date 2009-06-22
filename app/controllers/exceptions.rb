class Exceptions < Merb::Controller
  provides :json

  def bad_request
    display request.exceptions
  end

  def not_found
    display request.exceptions
  end

  def not_acceptable
    display request.exceptions
  end

  def unauthenticated
    display request.exceptions
  end
end
