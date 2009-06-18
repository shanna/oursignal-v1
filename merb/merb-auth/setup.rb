begin
  Merb::Authentication.user_class = User

  class Merb::Authentication
    def fetch_user(session_user_id)
      user = Merb::Authentication.user_class.find_first({:_id => session_user_id}.to_mongo)
      session.abandon! if user.nil?
      user
    end

    def store_user(user)
      user.nil? ? user : user[:_id]
    end
  end
end

