begin
  Merb::Authentication.user_class = User

  class Merb::Authentication
    def fetch_user(session_user_id)
      Merb::Authentication.user_class.get(session_user_id)
    end

    def store_user(user)
      user.nil? ? user : user.id
    end
  end
end

