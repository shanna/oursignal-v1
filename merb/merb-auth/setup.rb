Merb::Plugins.config[:'merb-auth'][:login_param]    = :username
Merb::Plugins.config[:'merb-auth'][:password_param] = :password

begin
  Merb::Authentication.user_class = User

  class Merb::Authentication
    def fetch_user(session_user_id)
      user = Merb::Authentication.user_class.get(session_user_id)
      session.abandon! if user.nil?
      user
    end

    def store_user(user)
      user.nil? ? user : user.id
    end
  end
end

