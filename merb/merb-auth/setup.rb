begin
  Merb::Authentication.user_class = User

  class Merb::Authentication
    def fetch_user(session_user_id)
      user = Merb::Authentication.user_class.first(session_user_id)
      session.abandon! if user.nil?
      user
    end

    def store_user(user)
      user.nil? ? user : user.id
    end
  end
end

