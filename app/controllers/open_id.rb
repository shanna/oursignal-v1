class OpenId < Merb::Controller
  before :ensure_openid_url

  def signup
    # TODO: Thats one ugly interface.
    # TODO: The openid basic strategy needs work. It doesn't pass openid.fullname via the session like it should.
    user = Merb::Authentication.user_class.repsert(
      {:'openid.identifier' => session['openid.url']}.to_mongo,
      {
        :openid   => {:identifier => session['openid.url']},
        :email    => session['openid.email'],
        :fullname => session['openid.fullname'],
        :username => session['openid.nickname'],
        :feeds    => []
      }.to_mongo
    )

    if user
      session.user = user
      redirect url(:users, session.user[:username]), :message => {:notice => 'Signup was successful'}
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
