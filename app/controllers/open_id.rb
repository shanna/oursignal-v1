class OpenId < Merb::Controller
  before :ensure_openid_url

  def signup
    # TODO: Thats one ugly interface.
    # TODO: The openid basic strategy needs work. It doesn't pass openid.fullname via the session like it should.
    user = unless Merb::Authentication.user_class.first(:openid => session['openid.url'])
      User.create(
        :openid   => session['openid.url'],
        :email    => session['openid.email'],
        :username => session['openid.nickname'],
        :fullname => session['openid.fullname']
      )
    end

    if user
      session.user = user
      redirect url(:users, session.user.username), :message => {:notice => 'Signup was successful'}
    else
      message[:error] = 'There was an error while creating your user account'
      redirect(url(:openid))
    end
  end

  private
    def ensure_openid_url
      throw :halt, redirect(url(:openid)) if session['openid.url'].nil?
    end
end
